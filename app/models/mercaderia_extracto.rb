class MercaderiaExtracto < MovimientoModel

  self.movimiento_key = [:mercaderia_id]
  self.balances = 'MercaderiaPeriodoBalance'

  belongs_to :mercaderia

  belongs_to :movimiento_mercaderia_detalle
  has_one :movimiento_mercaderia, through: :movimiento_mercaderia_detalle

  belongs_to :boleta_detalle
  has_one :boleta, through: :boleta_detalle

  belongs_to :nota_credito_debito_detalle
  has_one :notas_creditos_debito, through: :nota_credito_debito_detalle

end
