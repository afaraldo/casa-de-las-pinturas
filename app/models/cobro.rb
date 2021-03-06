class Cobro < Recibo

  belongs_to :persona, -> { with_deleted }, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Cliente'

  has_many :boletas_detalles, class_name: 'CobroVenta', dependent: :destroy, foreign_key: "recibo_id", inverse_of: :recibo
  has_many :boletas, class_name: 'Venta', through: :boletas_detalles

  delegate :nombre, to: :persona, prefix: true

  def build_detalles(monedas_usadas = [])
    Moneda.all.each do |m|
      unless monedas_usadas.include?(m.id)
        detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
      end
    end
        detalles.build(moneda: Moneda.first, forma: :tarjeta, monto: 0, cotizacion: 1)

  end

  # calcula si se va a producir saldo negativo para algunas monedas en la caja efectivo
  def check_detalles_negativos(deleted = false)

    monedas = detalles.map(&:moneda_id) # monedas de los detalles
    caja = Caja.get_caja_por_forma(:efectivo) # caja efectivo
    saldos = caja.saldos_por_moneda(monedas) # saldos de esas monedas

    if deleted
      detalles.each do |d|
        saldos[d.moneda_id] -= (d.monto)
      end
    else
      detalles.each do |d|
        saldos[d.moneda_id] += (d.monto - d.monto_was.to_f)
      end
    end
    monedas_negativas = saldos.map{ |m, v| m if v < 0 }.compact
    monedas_negativas.empty? ? [] : Moneda.find(monedas_negativas) # retorna un conjunto de monedas que pueden quedar con saldo negativo
  end

  # Agregar las monedas que no estan presentes
  # esto es para cuando se edita o hay un error al tratar de guardar
  def rebuild_detalles
    build_detalles(detalles.map(&:moneda_id))
  end

end
