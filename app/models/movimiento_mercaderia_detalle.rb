class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  after_save :update_stock
  after_destroy :update_stock

  belongs_to :movimiento_mercaderia, inverse_of: :detalles
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than: 0 }
  validate  :check_stock_negativo

  # Comprobar que la cantidad no provoque stock negativo
  def check_stock_negativo
    if nueva_cantidad < 0
      errors.add(:cantidad, I18n.t('movimiento_mercaderia.detalle_cantidad_stock_negativo'))
      false
    end
  end

  def nueva_cantidad(borrado = false)
    nueva_cantidad = deleted? || borrado ? 0 : cantidad
    nueva_cantidad_diff = nueva_cantidad - cantidad_was.to_f

    cantidad_ = mercaderia.stock
    cantidad_ += nueva_cantidad_diff if movimiento_mercaderia.tipo == :ingreso
    cantidad_ -= nueva_cantidad_diff if movimiento_mercaderia.tipo == :egreso
    cantidad_
  end

  # Actualizar el stock si es que cambio la cantidad o se elimino el detalle
  def update_stock
    mercaderia.update(stock: nueva_cantidad) if cantidad_changed? || deleted?
  end

end
