class CajaExtracto < MovimientoModel

  self.movimiento_key = [:caja_id, :moneda_id]
  self.balances = 'CajaPeriodoBalance'

  belongs_to :caja
  belongs_to :moneda

  # movimientos de caja
  belongs_to :caja_movimiento_detalle
  has_one :caja_movimiento, through: :caja_movimiento_detalle

  # recibos detalles
  belongs_to :recibo_detalle
  has_one :recibo, through: :recibo_detalle


end
