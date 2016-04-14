class Pago < Recibo

  belongs_to :proveedor, foreign_key: 'persona_id'

  delegate :nombre, to: :proveedor, prefix: true

  def build_detalles
    Moneda.all.each do |m|
      detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
    end
  end

end
