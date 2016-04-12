class Boleta < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  self.inheritance_column = 'tipo'

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :condicion, in: [:contado, :credito], predicates: true
  enumerize :estado, in: [:pendiente, :cancelado], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  #Callbacks
  before_validation :set_importe_total
  before_validation :set_importe_pendiente
  before_validation :set_estado

  #after_save :actualizar_extracto
  #after_save :actualizar_cuenta_corriente
  #after_destroy :actualizar_cuenta_corriente

  # Validations
  validates :fecha,  presence: true
  validate  :fecha_futura
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :tipo,   presence: true
  validates :persona_id, presence: true
  validates :detalles, length: { minimum: 1 }
  validates :condicion, presence: true
  #validate  :condicion_changed?, on: :update

  with_options if: :credito? do |b|
    b.validates :fecha_vencimiento, presence: true
    b.validate  :fecha_vencimiento_menor_a_fecha
    b.validate  :supera_limite_de_credito?
  end

  def numero
    id
  end

  def importe_pagado
    self.importe_total - self.importe_pendiente
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
    self.pagos_detalles.each do |p|
      monto_pagado += p.monto_utilizado
    end
    self.importe_pendiente = self.importe_total - monto_pagado
  end

  def set_estado
    if self.importe_pendiente == 0
      self.estado = self.class.estado.values[1]
    else
      self.estado = self.class.estado.values[0]
    end
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

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  def fecha_vencimiento_menor_a_fecha

    if fecha_vencimiento && fecha > fecha_vencimiento
      errors.add(:fecha_vencimiento, I18n.t('activerecord.errors.messages.fecha_vencimiento'))
    end
  end



  def condicion_cambiada?
    if condicion_changed? && self.persisted?
      errors.add(:condicion, I18n.t('activerecord.errors.messages.no_editable'))
      true
    end
  end

  def actualizar_extracto
    if fecha_changed? ##### PORQUE SOLO POR FECHA??
        CuentaCorrienteExtracto.crear_o_actualizar_extracto(self, fecha, 0, importe_pendiente)
    end
  end

  def supera_limite_de_credito?
    if importe_total > self.persona.limite_credito - self.persona.saldo_actual
      errors.add(:persona, I18n.t('activerecord.errors.messages.supera_limite_de_credito'))
      true
    end
  end

  # Actualizar la cuenta corriente si es que cambio el importe_pendiente
  def actualizar_cuenta_corriente

  end
end
