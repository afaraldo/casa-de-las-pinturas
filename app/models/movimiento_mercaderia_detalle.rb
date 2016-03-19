class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :movimiento_mercaderia
  belongs_to :mercaderia

  validates :cantidad, numericality: { greater_than_or_equal_to: 0.001 }

end
