class CajaMovimientoDetalle < ActiveRecord::Base
  acts_as_paranoid
  attr_accessor :caja_id
  after_save :actualizar_extractos
  after_destroy :actualizar_extractos

  belongs_to :caja_movimiento, inverse_of: :detalles
  belongs_to :moneda

  delegate :nombre, to: :caja, prefix: true

  validates :monto, numericality: { greater_than: 0, less_than_or_equal_to: DECIMAL_LIMITE[:superior] }
  validates :forma, presence: true

  def actualizar_extractos
    self.caja_id = Caja.get_caja_por_forma(forma).id
    operador = self.caja_movimiento ? -1 : 1

    if deleted?
      CajaExtracto.eliminar_movimiento(self, self.caja_movimiento.fecha, monto * operador * -1)
    else
      CajaExtracto.crear_o_actualizar_extracto(self, self.caja_movimiento.fecha, monto_was.to_f * operador, monto.to_f * operador)
    end
  end

end
