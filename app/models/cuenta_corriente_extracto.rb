class CuentaCorrienteExtracto < MovimientoModel

  self.movimiento_key = [:persona_id]
  self.balances = 'CuentaCorrientePeriodoBalance'
  
  belongs_to :persona
  belongs_to :boleta


end
