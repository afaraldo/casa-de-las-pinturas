class Boleta < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  self.inheritance_column = 'tipo'

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :condicion, in: [:contado, :credito], predicates: true
  enumerize :estado, in: [:pendiente, :pagado], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  before_save :set_importe_total, :set_importe_pendiente, :set_estado

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
  validate  :fecha_futura, :fecha_vencimiento_mayor_a_fecha


  def numero
    id
  end

  private

  def set_importe_total
    self.importe_total = 0
    self.detalles.each do |detalle|
        self.importe_total += detalle.precio_unitario
    end
  end

  def set_importe_pendiente
    self.importe_pendiente ||= 0
  end

  def set_estado
    if importe_pendiente == 0
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

  def fecha_vencimiento_mayor_a_fecha
    if fecha > fecha_vencimiento
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_vencimiento'))
    end
  end

end
