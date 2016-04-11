class Boleta < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  self.inheritance_column = 'tipo'

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :condicion, in: [:contado, :credito], predicates: true
  enumerize :estado, in: [:pendiente, :pagado], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
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
