class CuentaCorrienteExtracto < MovimientoModel
  belongs_to :persona
  belongs_to :boleta

  self.movimiento_key = [:persona_id]
  self.balances = 'CuentaCorrientePeriodoBalance'
end
