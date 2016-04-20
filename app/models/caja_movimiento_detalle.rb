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

  def nuevo_monto(borrado = false)
    nuevo_monto = deleted? || borrado ? 0 : monto
    nuevo_monto_diff = nuevo_monto - monto_was.to_f

    monto_ = caja_saldo.saldo_efectivo
    monto_ += nuevo_monto_diff if caja_movimiento.tipo == :ingreso
    monto_ -= nuevo_monto_diff if caja_movimiento.tipo == :egreso
    monto_
  end

  def actualizar_extractos
    self.caja_id = Caja.get_caja_por_forma(forma).id
    operador = self.caja_movimiento.tipo.ingreso? ? -1 : 1
    if deleted?
      CajaExtracto.eliminar_movimiento(self, self.caja_movimiento.fecha, monto * operador * -1)
    else
      CajaExtracto.crear_o_actualizar_extracto(self, self.caja_movimiento.fecha, monto_was.to_f * operador, monto * operador)
    end
  end

end
