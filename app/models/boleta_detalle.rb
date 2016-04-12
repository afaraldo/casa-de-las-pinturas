class BoletaDetalle < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :boleta, inverse_of: :detalles
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than: 0, less_than_or_equal_to: DECIMAL_LIMITE[:superior] }
  validates :precio_unitario, numericality: { greater_than: 0, less_than: 1_000_000_000_000 }
end
