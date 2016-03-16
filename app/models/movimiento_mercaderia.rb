class MovimientoMercaderia < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid

  has_many :detalles, class_name: 'MovimientoMercaderiaDetalle', dependent: :destroy

  accepts_nested_attributes_for :detalles

  enumerize :tipo, in: [:ingreso, :egreso], predicates: true

  default_scope { order('fecha') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :motivo, presence: true, length: {maximum: 255, minimum: 2}

end
