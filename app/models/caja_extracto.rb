class CajaExtracto < MovimientoModel

  self.movimiento_key = [:caja_id, :moneda_id]
  self.balances = 'CajaPeriodoBalance'

  belongs_to :caja
  belongs_to :moneda

  # movimientos de caja
  belongs_to :caja_movimiento_detalle
  has_one :caja_movimiento, through: :caja_movimiento_detalle

  # recibos detalles
  belongs_to :recibo_detalle
  has_one :recibo, through: :recibo_detalle

  def self.reporte(*args)
    opciones = args.extract_options!

    opciones[:agrupar_por] = 'dia' if opciones[:agrupar_por].nil?
    opciones[:order_by] = 'grupo' if opciones[:order_by].nil?
    opciones[:order_dir] = 'asc' if opciones[:order_dir].nil?

    resultado = self.where(fecha: opciones[:desde]..opciones[:hasta])
                    .where(caja_id: opciones[:caja_id])
                    .where(moneda_id: opciones[:moneda_id])

    grupo_formato = (opciones[:agrupar_por] == 'dia') ? 'default' : opciones[:agrupar_por]

    if opciones[:resumido]
      grupo = "to_char(fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

      resultado.select("#{grupo} as grupo, sum(importe_total) as total")
               .order("#{opciones[:order_by]} #{opciones[:order_dir]}")
               .group("#{grupo}")
               .page(opciones[:page]).per(opciones[:limit])

    else
      resultado = resultado.order('fecha asc')
                           .page(opciones[:page]).per(opciones[:limit])

      {todo: resultado, agrupado: resultado.group_by { |b| I18n.localize(b.fecha.to_date, format: grupo_formato.to_sym).capitalize }}
    end
  end
end
