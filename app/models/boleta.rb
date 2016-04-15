class Boleta < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  self.inheritance_column = 'tipo'

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas#, counter_cache: true

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  has_many :recibos_detalles, class_name: 'ReciboBoleta', foreign_key: "boleta_id", inverse_of: :boleta, dependent: :destroy
  has_many :recibos, class_name: 'Recibo', dependent: :destroy, through: :recibos_detalles

  enumerize :condicion, in: [:contado, :credito], predicates: true
  enumerize :estado, in: [:pendiente, :pagado], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  #Callbacks
  before_validation :set_importe_total
  before_validation :set_importe_pendiente
  before_validation :set_estado

  after_save :actualizar_extracto_de_cuenta_corriente
  after_destroy :actualizar_extracto_de_cuenta_corriente

  after_save :actualizar_extractos_de_mercaderias
  after_destroy :actualizar_extractos_de_mercaderias

  # Validations
  validates :fecha,  presence: true
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :tipo,   presence: true
  validates :persona, presence: true
  validates :detalles, length: { minimum: 1 }
  validates :condicion, presence: true
  validate  :condicion_cambiada?, on: :update

  with_options if: :credito? do |b|
    b.validates :fecha_vencimiento, presence: true
    b.validate  :fecha_vencimiento_es_menor_a_fecha?
    b.validate  :supera_limite_de_credito?
  end

  def numero
    id
  end

  def importe_pagado
    self.importe_total - self.importe_pendiente
  end

  def check_detalles_negativos(borrado = false)
    m = []
    detalles.each do |d|
      if d.nueva_cantidad(borrado) < 0
        m << d.mercaderia
      end
    end
    if m.size > 0
      #errors.add(:base, I18n.t('movimiento_mercaderia.eliminar_stock_negativo', mercaderias: m.map{|me| me.nombre}.to_sentence))
    end
    m
  end


  private

  def set_importe_total
    self.importe_total = 0
    self.detalles.each do |detalle|
        self.importe_total += detalle.precio_unitario * detalle.cantidad
    end
  end

  def set_importe_pendiente
    monto_pagado = 0
    self.recibos_detalles.each do |p|
      monto_pagado += p.monto_utilizado
    end
    self.importe_pendiente = self.importe_total - monto_pagado
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
    if fecha_vencimiento < fecha
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
    if importe_total > (persona.limite_credito - persona.saldo_actual)
      errors.add(:persona, I18n.t('activerecord.errors.messages.supera_limite_de_credito'))
      false
    end
  end

  # Actualiza la cuenta corriente si es que se guardo o actualizo
  def actualizar_extracto_de_cuenta_corriente
    CuentaCorrienteExtracto.crear_o_actualizar_extracto(self.becomes(Boleta), fecha, importe_pendiente_was.to_f, importe_pendiente)
  end

  # Actualiza el extracto de las mercaderias si se cambio de la fecha de la boleta
  def actualizar_extractos_de_mercaderias
    if fecha_changed?
      detalles.each do |d|
        MercaderiaExtracto.crear_o_actualizar_extracto(d, fecha, d.cantidad, d.cantidad)
      end
    end
  end

end
