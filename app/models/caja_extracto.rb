class CajaExtracto < ActiveRecord::Base
  
  self.movimiento_key = [:caja_id]
  self.balances = 'CajaPeriodoBalance'

  belongs_to :caja
  belongs_to :moneda
  belongs_to :caja_movimiento_detalle
  has_one :caja_movimiento, through: :caja_movimiento_detalle

end
