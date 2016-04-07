class MercaderiaExtracto < MovimientoModel
  self.movimiento_key = [:mercaderia_id]

  belongs_to :mercaderia
  belongs_to :movimiento_mercaderia_detalle

end
