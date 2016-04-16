class Pago < Recibo

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'

  delegate :nombre, to: :persona, prefix: true

  def build_detalles(monedas_usadas = [])
    Moneda.all.each do |m|
      unless monedas_usadas.include?(m.id)
        detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
      end
    end
  end

  # Agregar las monedas que no estan presentes
  # esto es para cuando se edita o hay un error al tratar de guardar
  def rebuild_detalles
    build_detalles(detalles.map(&:moneda_id))
  end

end
