class Boleta < ActiveRecord::Base
  include SqlHelper
  extend Enumerize
  acts_as_paranoid

  self.inheritance_column = 'tipo'

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta

  has_many :recibos_detalles, class_name: 'ReciboBoleta', foreign_key: "boleta_id", inverse_of: :boleta
  has_many :recibos, class_name: 'Recibo', through: :recibos_detalles

  has_many :nota_credito_debito_detalles, class_name: 'DevolucionesBoleta', foreign_key: "boleta_id", inverse_of: :boleta, dependent: :destroy
  has_many :notas_creditos_debitos, class_name: 'NotasCreditosDebito', dependent: :destroy, through: :nota_credito_debito_detalles

  has_many :creditos_detalles, class_name: 'BoletaNotaCreditoDebito', foreign_key: "boleta_id", inverse_of: :boleta, dependent: :destroy
  has_many :creditos, class_name: 'NotasCreditosDebito', dependent: :destroy, through: :creditos_detalles, source: :notas_creditos_debito

  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :recibos_detalles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :creditos_detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :condicion, in: [:contado, :credito], predicates: true
  enumerize :estado, in: [:pendiente, :pagado], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  #Callbacks

  before_validation :set_importe_total
  before_validation :set_importe_credito_utilizado
  before_validation :set_importe_pendiente
  before_validation :set_estado
  before_validation :set_pago, if: :contado?
  after_validation :check_detalles, on: :update

  after_save :actualizar_extracto_de_cuenta_corriente, if: :credito?
  after_destroy :actualizar_extracto_de_cuenta_corriente, if: :credito?
  before_destroy :destroy_pagos

  after_save :actualizar_extractos_de_mercaderias

  # Validations
  validates :fecha,  presence: true
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :tipo,   presence: true
  validates :persona, presence: true
  validates :detalles, length: { minimum: 1 }
  validates :condicion, presence: true
  validates :importe_total, numericality: { greater_than: 0, less_than: DECIMAL_LIMITE[:superior] }
  validate  :condicion_cambiada?, on: :update
  validate :tiene_pagos_asociados?, on: [:update, :destroy]
  validate :fecha_futura

  with_options if: :credito? do |b|
    b.validates :fecha_vencimiento, presence: true
    b.validate  :fecha_vencimiento_es_menor_a_fecha?
    b.validate  :supera_limite_de_credito?, on: :create
  end

  # Se controlan los posibles detalles y saldos negativos y se guarda la boleta
  def guardar(atributos, guardar_si_o_si)
    if new_record?
      self.assign_attributes(atributos)
    else
      self.update_attributes(atributos)
    end

    stock_negativo = controlar_stock_negativo(guardar_si_o_si) if self.instance_of?(Compra)
    stock_negativo = guardar_si_o_si ? [] : self.check_detalles_negativos if self.instance_of?(Venta)
    saldo_negativo = guardar_si_o_si ? [] : self.check_detalles_negativos_pago

    errors.add(:stock_negativo, "La operación va a provocar existencia negativa en los siguientes productos: #{stock_negativo.map {|m| m.nombre }.to_sentence}") if stock_negativo.size > 0
    errors.add(:saldo_negativo, "La operación va a provocar disponibilidad negativa en los siguientes monedas: #{saldo_negativo.map {|m| m.nombre }.to_sentence}") if saldo_negativo.size > 0
    stock_negativo.size <= 0 && saldo_negativo.size <= 0 && save
  end

  # si la boleta es compra y es nueva no provoca stock negativo
  def controlar_stock_negativo(guardar_si_o_si)
    guardar_si_o_si || new_record? && self.instance_of?(Compra) ? [] : self.check_detalles_negativos
  end

  def numero
    id
  end

  def es_editable?
    if (credito? && recibos_detalles.empty?) || contado?
      true
    else
      false
    end
  end

  def importe_pagado
    self.importe_total - self.importe_pendiente - self.importe_credito_utilizado
  end

  def set_pago

    recibo_boleta = recibos_detalles.first
    recibo_boleta.monto_utilizado = importe_total - importe_credito_utilizado

    # HACK? Para forzar que se actualize el recibo_detalle y se actualice el recibo.
    # Porque pasa esto?: es un misterio todavia. :)
    recibo_boleta.updated_at = Time.zone.now
    #---------------------------------------

    recibo_boleta.recibo.fecha = fecha
    recibo_boleta.recibo.condicion = "contado"
    recibo_boleta.recibo.persona = persona
    recibo_boleta.recibo.boletas_detalles = [recibo_boleta] # Para que la validacion de recibo tenga el nuevo monto_utilizado

  end

  def destroy_pagos
    unless recibos.empty?
      recibos.each(&:destroy)
    end
  end

  # recargar los detalles si hay algun error
  def check_detalles
    detalles.reload if errors.size > 0
  end

  def check_detalles_negativos(borrado = false)
    m = []
    detalles.each do |d|
      if d.nueva_cantidad(borrado) < 0
        m << d.mercaderia
      end
    end
    m
  end

  def check_detalles_negativos_pago(borrado = false)
    m = []
    recibo_detalle = recibos_detalles.first
    pago = recibo_detalle.recibo if recibo_detalle
    if pago
      m = pago.check_detalles_negativos borrado
    end
    m
  end

  def tiene_pagos_asociados?
    valid = true
    # no se permite editar la persona ni el importe si la boleta tiene un pago
    if importe_total_changed? && !recibos_detalles.empty?
      errors.add(:persona, I18n.t('activerecord.errors.messages.importe_no_editable'))
      valid = false
    end
    if persona_id_changed? && !recibos_detalles.empty?
      errors.add(:persona, I18n.t('activerecord.errors.messages.persona_no_editable'))
      valid = false
    end
  end


  def movimiento_motivo
    "#{tipo} Nro. #{numero}"
  end

  def self.reporte(*args)

    opciones = args.extract_options!

    opciones[:agrupar_por] = 'dia' if opciones[:agrupar_por].nil?
    opciones[:order_by] = 'grupo' if opciones[:order_by].nil?
    opciones[:order_dir] = 'asc' if opciones[:order_dir].nil?

    resultado = self.unscoped.where(deleted_at: nil).where(fecha: opciones[:desde]..opciones[:hasta])

    resultado = resultado.where(persona_id: opciones[:persona_id]) unless opciones[:persona_id].blank?

    grupo_formato = (opciones[:agrupar_por] == 'dia') ? 'default' : opciones[:agrupar_por]

    if opciones[:resumido]
      grupo = opciones[:agrupar_por] == 'persona' ? 'personas.nombre' : "to_char(fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

      resultado.joins(:persona)
               .select("#{grupo} as grupo, sum(importe_total - importe_descontado) as total")
               .order("#{opciones[:order_by]} #{opciones[:order_dir]}")
               .group("#{grupo}")
               .page(opciones[:page]).per(opciones[:limit])

    else
      resultado = resultado.includes(:persona)
                           .order("#{(opciones[:agrupar_por] == 'persona') ? 'personas.nombre' : 'fecha'} asc")
                           .page(opciones[:page]).per(opciones[:limit])

      {todo: resultado, agrupado: resultado.group_by { |b| (opciones[:agrupar_por] == 'persona') ? b.persona_nombre :  I18n.localize(b.fecha.to_date, format: grupo_formato.to_sym).capitalize }}
    end

    def self.reporte_mensual(*args)
      fechas = Boleta.select("fecha").group(:fecha)
      compras = Compra.reporte(args)
      ventas = Venta.reporte(args)

    end

  end

  private

  # carga el campo importe_total = suma de los (precio_unitario * cantidad) de cada detalle
  def set_importe_total
    self.importe_total = 0
    self.detalles.each do |detalle|
        self.importe_total += detalle.precio_unitario * detalle.cantidad unless detalle.marked_for_destruction?
    end
  end

  def set_importe_credito_utilizado
    if credito?
      self.importe_credito_utilizado = 0
    else
      monto_usado = 0
      self.creditos_detalles.each do |p|
        monto_usado += p.monto_utilizado unless p.marked_for_destruction?
      end
      self.importe_credito_utilizado = monto_usado
    end
  end

  #calcula el importe_pendiente, si la boleta es nueva importe_pendiente = importe_total sino importe_pendiente = (importe_total - montos_pagados)
  def set_importe_pendiente
    if new_record?
      self.importe_pendiente = importe_total - importe_credito_utilizado
    else
      monto_pagado = 0
      self.recibos_detalles.each do |p|
        monto_pagado += (p.monto_utilizado ? p.monto_utilizado : 0)
      end
      self.importe_pendiente = self.importe_total - importe_credito_utilizado - monto_pagado
    end
  end

  def set_estado
    if self.importe_pendiente == 0
      self.estado = :pagado
    else
      self.estado = :pendiente
    end
  end

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  def fecha_vencimiento_es_menor_a_fecha?
    if fecha_vencimiento && fecha_vencimiento < fecha
      errors.add(:fecha_vencimiento, I18n.t('activerecord.errors.messages.fecha_vencimiento'))
    end
  end

  def condicion_cambiada?
    if condicion_changed? && self.persisted?
      errors.add(:condicion, I18n.t('activerecord.errors.messages.no_editable'))
      false
    end
  end

  def supera_limite_de_credito?
    if importe_pendiente  > (persona.limite_credito - persona.saldo_actual)
      errors.add(:persona, I18n.t('activerecord.errors.messages.supera_limite_de_credito'))
      false
    end
  end

  # Actualiza la cuenta corriente si es que se guardo o actualizo
  def actualizar_extracto_de_cuenta_corriente
    if deleted?
      CuentaCorrienteExtracto.eliminar_movimiento(self.becomes(Boleta), fecha, importe_pendiente * -1)
    else
      if persona_id_changed? && !persona_id_was.nil? # si cambio de cuenta corriente
        old = get_old_boleta
        CuentaCorrienteExtracto.eliminar_movimiento(old.becomes(Boleta), fecha_was, importe_pendiente_was * -1)
        CuentaCorrienteExtracto.crear_o_actualizar_extracto(self.becomes(Boleta), fecha, 0, importe_pendiente)
      else
        CuentaCorrienteExtracto.crear_o_actualizar_extracto(self.becomes(Boleta), fecha, importe_pendiente_was.to_f, importe_pendiente)
      end
    end
  end

  def get_old_boleta
    old = self.dup
    old.id = self.id
    old.persona_id = persona_id_was

    old
  end

  # Actualiza el extracto de las mercaderias si se cambio de la fecha de la boleta
  def actualizar_extractos_de_mercaderias
    if fecha_changed?
      detalles.each do |d|
        MercaderiaExtracto.crear_o_actualizar_extracto(d, fecha, d.cantidad, d.cantidad)
      end
    end
  end

  # para poder buscar por el id y numero comprobante
  ransacker :id do
    Arel.sql("to_char(\"#{table_name}\".\"id\", '99999')")
  end

  # Devuelve la sumatoria de todos importes_totales de las boletas de un tipo
  # durante un periodo de tiempo seleccionado
  def self.importe_total_boletas(fecha_inicio, fecha_fin, tipo, condicion)
    saldo = 0
    boletas = Boleta.where("fecha >= ? AND fecha <= ? AND tipo = ? AND condicion = ?", fecha_inicio, fecha_fin, tipo, condicion)
    boletas.map{|b| saldo += b.importe_total }
    saldo
  end

end
