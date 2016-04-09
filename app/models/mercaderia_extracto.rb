class MercaderiaExtracto < MovimientoModel

  self.movimiento_key = [:mercaderia_id]
  self.balances = 'MercaderiaPeriodoBalance'

  belongs_to :mercaderia
  belongs_to :movimiento_mercaderia_detalle
  has_one :movimiento_mercaderia, through: :movimiento_mercaderia_detalle

end
