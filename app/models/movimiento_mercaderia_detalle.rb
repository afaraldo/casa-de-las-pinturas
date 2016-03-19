class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  after_save :update_stock
  after_destroy :update_stock

  belongs_to :movimiento_mercaderia
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than_or_equal_to: 0.001 }

  # Actualizar el stock si es que cambio la cantidad o se elimino el detalle
  def update_stock
    cantidad_ = (deleted? ? 0 : cantidad) - cantidad_was.to_f
    mercaderia.actualizar_stock(cantidad_, movimiento_mercaderia.tipo) if cantidad_changed? || deleted?
  end

end
