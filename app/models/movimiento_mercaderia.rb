class MovimientoMercaderia < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid

  has_many :detalles, class_name: 'MovimientoMercaderiaDetalle', dependent: :destroy

  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :tipo, in: [:ingreso, :egreso], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :motivo, presence: true, length: {maximum: 255, minimum: 2}
  validates :tipo,   presence: true
  validates :detalles, length: { minimum: 1 }

end
