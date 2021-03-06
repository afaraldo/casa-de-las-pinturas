class CajaMovimiento < ActiveRecord::Base
  extend Enumerize
  include SqlHelper

  acts_as_paranoid

  before_validation :set_importe_total
  before_destroy :check_detalles_negativos
  after_initialize :set_caja
  after_save :actualizar_extracto

  belongs_to :categoria_gasto

  after_save :actualizar_extracto

  has_many :detalles, class_name: 'CajaMovimientoDetalle', dependent: :destroy, inverse_of: :caja_movimiento

  delegate :nombre, to: :categoria_gasto, prefix: true

  accepts_nested_attributes_for :detalles, reject_if: proc { |attrs| (attrs['monto'].to_f) <= 0 }, allow_destroy: true

  enumerize :tipo, in: [:ingreso, :egreso], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :motivo, presence: true, length: {maximum: 255, minimum: 2}
  validates :tipo,   presence: true
  validates :detalles, length: { minimum: 1 }
  validate  :fecha_futura
  validate :validar_categoria_gasto

  # Se controlan los posibles detalles y saldos negativos y se guarda la boleta
  def self.guardar_transferencia(fecha, monto, guardar_si_o_si)
    moneda_default = Moneda.find_by_defecto(true)
    if monto.blank?
      monto = 0
    end
    # Set attributes of CajaMovimiento - egreso
    movimiento_egreso = CajaMovimiento.new
    movimiento_egreso.fecha = fecha
    movimiento_egreso.motivo = "Transferencia de cuenta bancaria a caja registradora"
    movimiento_egreso.tipo = :egreso
    movimiento_egreso.caja_id = Caja.get_caja_por_forma(:tarjeta).id
    movimiento_egreso.es_transferencia = true

    # Set attributes of CajaMovimientoDetalle
    movimiento_egreso_detalle = movimiento_egreso.detalles.build
    movimiento_egreso_detalle.monto = monto
    movimiento_egreso_detalle.cotizacion = moneda_default.cotizacion
    movimiento_egreso_detalle.moneda_id = moneda_default.id
    movimiento_egreso_detalle.forma = :tarjeta

    # Set attributes of CajaMovimiento - ingreso
    movimiento_ingreso = CajaMovimiento.new
    movimiento_ingreso.fecha = fecha
    movimiento_ingreso.motivo = "Transferencia de cuenta bancaria a caja registradora"
    movimiento_ingreso.tipo = :ingreso
    movimiento_ingreso.caja_id = Caja.get_caja_por_forma(:efectivo).id
    movimiento_ingreso.es_transferencia = true

    # Set attributes of CajaMovimientoDetalle
    movimiento_ingreso_detalle = movimiento_ingreso.detalles.build
    movimiento_ingreso_detalle.monto = monto
    movimiento_ingreso_detalle.cotizacion = moneda_default.cotizacion
    movimiento_ingreso_detalle.moneda_id = moneda_default.id
    movimiento_ingreso_detalle.forma = :efectivo

    errors = []
    saldo_negativo = guardar_si_o_si ? [] : movimiento_egreso.check_detalles_negativos(false)
    errors.append("La operación va a provocar disponibilidad negativa en los siguientes monedas: #{saldo_negativo.map {|m| m.nombre }.to_sentence}") if saldo_negativo.size > 0

    unless movimiento_egreso.save && movimiento_ingreso.save
      key = movimiento_egreso.errors.messages.keys.first
      message = movimiento_egreso.errors.messages[key].first
      key = 'monto' if key == :'detalles.monto'
      errors =  [key.to_s + ' ' + message]
    end
    errors
  end

  def guardar(attributes, guardar_si_o_si)
    self.assign_attributes(attributes)
    saldo_negativo = guardar_si_o_si ? [] : self.check_detalles_negativos
    errors.add(:saldo_negativo, "La operación va a provocar disponibilidad negativa en los siguientes monedas: #{saldo_negativo.map {|m| m.nombre }.to_sentence}") if saldo_negativo.size > 0
    saldo_negativo.size >= 0 && save
  end

  def validar_categoria_gasto
    caja = Caja.get_caja_por_forma(:efectivo)
    if egreso? && caja_id == caja.id
      if !categoria_gasto
        errors.add(:categoria_gasto, I18n.t('activerecord.errors.messages.ingresar_categoria'))
      else
        true
      end
    else
      true
    end
  end

  def set_caja
    self.caja_id ||= Caja.get_caja_por_forma(:efectivo).id
  end

  def set_importe_total
    self.importe_total = 0

    detalles.each do |d|
      self.importe_total += d.monto * d.cotizacion
    end
  end

  def fecha_futura
    if fecha && fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  # calcula si se va a producir saldo negativo para algunas monedas en la caja efectivo
  def check_detalles_negativos(caja_efectivo = true)

    monedas = detalles.map(&:moneda_id) # monedas de los detalles

    if caja_efectivo
      caja = Caja.get_caja_por_forma(:efectivo) # caja efectivo
    else
      caja = Caja.get_caja_por_forma(:tarjeta) # caja tarjeta
    end
    saldos = caja.saldos_por_moneda(monedas) # saldos de esas monedas
    detalles.each do |d|
      saldos[d.moneda_id] -= (d.monto - d.monto_was.to_f)
    end
    monedas_negativas = saldos.map{ |m, v| m if v < 0 }.compact
    monedas_negativas.empty? ? [] : Moneda.find(monedas_negativas) # retorna un conjunto de monedas que pueden quedar con saldo negativo

  end

  def actualizar_extracto
    if fecha_changed?
      detalles.each do |d|
        CajaExtracto.crear_o_actualizar_extracto(d, fecha, d.monto, d.monto)
      end
    end
  end

  def build_detalles(monedas_usadas = [])
    Moneda.all.each do |m|
      unless monedas_usadas.include?(m.id)
        detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
      end
    end
  end

  # Agregar las monedas que no estan presentes
  # esto es para cuando se edita o hay un error al tratar de guardar
  def rebuild_detalles
    build_detalles(detalles.map(&:moneda_id))
  end

  def self.reporte_gastos(*args)

    opciones = args.extract_options!

    opciones[:agrupar_por] = 'dia' if opciones[:agrupar_por].nil?
    opciones[:order_by] = 'grupo' if opciones[:order_by].nil?
    opciones[:order_dir] = 'asc' if opciones[:order_dir].nil?

    resultado = self.unscoped.where(deleted_at: nil, tipo: :egreso).where(es_transferencia: false).where(fecha: opciones[:desde]..opciones[:hasta])

    resultado = resultado.where(categoria_gasto_id: opciones[:categoria_gasto_id]) unless opciones[:categoria_gasto_id].blank?

    grupo_formato = (opciones[:agrupar_por] == 'dia') ? 'default' : opciones[:agrupar_por]

    if opciones[:resumido]
      grupo = opciones[:agrupar_por] == 'categoria' ? 'categoria_gastos.nombre' : "to_char(fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

      resultado.joins(:categoria_gasto)
                .select("#{grupo} as grupo, sum(importe_total) as total")
                .order("#{opciones[:order_by]} #{opciones[:order_dir]}")
                .group("#{grupo}")
                .page(opciones[:page]).per(opciones[:limit])

    else
      resultado = resultado.includes(:categoria_gasto)
                           .order("#{(opciones[:agrupar_por] == 'categoria') ? 'categoria_gastos.nombre' : 'fecha'} asc")
                           .page(opciones[:page]).per(opciones[:limit])

      {todo: resultado, agrupado: resultado.group_by { |b| (opciones[:agrupar_por] == 'categoria') ? b.categoria_gasto_nombre :  I18n.localize(b.fecha.to_date, format: grupo_formato.to_sym).capitalize }}
    end

  end

end
