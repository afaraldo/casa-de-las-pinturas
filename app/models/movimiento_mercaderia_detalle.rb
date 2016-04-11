class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  after_save :update_stock
  after_destroy :update_stock

  belongs_to :movimiento_mercaderia, inverse_of: :detalles
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than: 0, less_than_or_equal_to: DECIMAL_LIMITE[:superior] }
  validate  :check_stock_rango

  # Comprobar que la cantidad no provoque stock negativo o que sea mayor al limite definido
  def check_stock_rango
    c = nueva_cantidad
 
    if c > DECIMAL_LIMITE[:superior]
      errors.add(:cantidad, I18n.t('movimiento_mercaderia.detalle_cantidad_stock_superior', limite: DECIMAL_LIMITE[:superior]))
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
    operador = self.movimiento_mercaderia.tipo.ingreso? ? 1 : -1
    if deleted?
      MercaderiaExtracto.eliminar_movimiento(self, self.movimiento_mercaderia.fecha, cantidad * operador * -1)
    else
      MercaderiaExtracto.crear_o_actualizar_extracto(self, self.movimiento_mercaderia.fecha, cantidad_was.to_f * operador, cantidad * operador)
    end
    mercaderia.update(stock: nueva_cantidad) if cantidad_changed? || deleted?
  end

end
