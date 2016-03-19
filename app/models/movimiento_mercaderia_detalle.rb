class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  after_create :update_stock

  belongs_to :movimiento_mercaderia
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than_or_equal_to: 0.001 }

  def update_stock
    mercaderia.actualizar_stock(cantidad, movimiento_mercaderia.tipo)
  end
end
