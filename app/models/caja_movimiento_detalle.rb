class CajaMovimientoDetalle < ActiveRecord::Base
  acts_as_paranoid

  after_save :update_caja_saldos
  after_destroy :update_caja_saldos

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

  # Actualizar el saldo si es que cambio el monti o se elimino el detalle
  def update_caja_saldos
    operador = self.caja_movimiento.tipo.ingreso? ? 1 : -1
    if deleted?
      CajaExtracto.eliminar_movimiento(self, self.caja_movimiento.fecha, monto * operador * -1)
    else
      CajaExtracto.crear_o_actualizar_extracto(self, self.caja_movimiento.fecha, monto_was.to_f * operador, monto * operador)
    end
    caja.update(caja_saldo: nueva_monto) if monto_changed? || deleted?
  end

end
