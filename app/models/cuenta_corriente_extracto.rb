class CuentaCorrienteExtracto < MovimientoModel

  self.movimiento_key = [:persona_id]
  self.balances = 'CuentaCorrientePeriodoBalance'

  belongs_to :notas_creditos_debito
  belongs_to :persona
  belongs_to :boleta
  belongs_to :recibo

end
