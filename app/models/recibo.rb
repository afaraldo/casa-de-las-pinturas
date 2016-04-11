class Recibo < ActiveRecord::Base

  acts_as_paranoid

  self.inheritance_column = 'tipo'

  has_many :detalles, class_name: 'ReciboDetalle', dependent: :destroy, inverse_of: :recibo
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validate  :fecha_futura

  def numero
    id
  end

  private

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

end
