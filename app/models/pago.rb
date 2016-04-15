class Pago < Recibo

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'

  delegate :nombre, to: :persona, prefix: true

  def build_detalles
    Moneda.all.each do |m|
      detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
    end
  end

  def movimiento_motivo
    "Pago Nro. #{numero}"
  end

end
