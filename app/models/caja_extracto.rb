class CajaExtracto < MovimientoModel
  include SqlHelper

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

    opciones[:caja_id] = Caja.get_caja_por_forma(:efectivo).id if opciones[:caja_id].nil?
    opciones[:moneda_id] = Moneda.first.id if opciones[:moneda_id].nil?
    opciones[:agrupar_por] = 'dia' if opciones[:agrupar_por].nil?
    opciones[:order_by] = 'grupo' if opciones[:order_by].nil?
    opciones[:order_dir] = 'asc' if opciones[:order_dir].nil?

    resultado = self.where(fecha: opciones[:desde]..opciones[:hasta])
                    .where(caja_id: opciones[:caja_id])
                    .where(moneda_id: opciones[:moneda_id])

    grupo_formato = (opciones[:agrupar_por] == 'dia') ? 'default' : opciones[:agrupar_por]

    if opciones[:resumido]
      opciones[:tipo] = 'egreso'
      egresos = get_by_tipo(opciones)

      opciones[:tipo] = 'ingreso'
      ingresos = get_by_tipo(opciones)

      grupos = ingresos.keys + egresos.keys

      res = []

      grupos.uniq.each do |g|
        res << [g, ingresos[g].to_f, egresos[g].to_f]
      end

      order_resumido(res, opciones[:order_by], opciones[:order_dir])

    else
      resultado = resultado.order('fecha asc')
                           .page(opciones[:page]).per(opciones[:limit])

      {todo: resultado, agrupado: resultado.group_by { |b| I18n.localize(b.fecha.to_date, format: grupo_formato.to_sym).capitalize }}
    end
  end

  def self.order_resumido(data, order_by, order_dir)
    order_index = 0
    order_index = 1 if order_by == 'ingreso'
    order_index = 2 if order_by == 'egreso'

    ordenado = data.sort_by { |g| g[order_index] }

    ordenado = ordenado.reverse! if order_dir == 'desc'

    ordenado
  end

  def self.get_by_tipo(*args)
    opciones = args.extract_options!
    grupo = "to_char(recibos.fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

    recibos = ReciboDetalle.joins(:recibo)
                .select("#{grupo} as grupo, sum(monto * cotizacion) as total")
                .where('recibos.fecha >= ? AND recibos.fecha <= ?', opciones[:desde], opciones[:hasta])
                .where(caja_id: opciones[:caja_id])
                .where(moneda_id: opciones[:moneda_id])
                .where("recibos.tipo = '#{opciones[:tipo] == 'egreso' ? 'Pago' : 'Cobro'}'")
                .group("#{grupo}")
                # .page(opciones[:page]).per(opciones[:limit])

    grupo = "to_char(caja_movimientos.fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

    caja_movimientos = CajaMovimientoDetalle.joins(:caja_movimiento)
                                    .select("#{grupo} as grupo, sum(monto * cotizacion) as total")
                                    .where('caja_movimientos.fecha >= ? AND caja_movimientos.fecha <= ?', opciones[:desde], opciones[:hasta])
                                    .where("caja_movimientos.caja_id = '#{opciones[:caja_id]}'")
                                    .where(moneda_id: opciones[:moneda_id])
                                    .where("caja_movimientos.tipo = '#{opciones[:tipo]}'")
                                    .group("#{grupo}")
                                    # .page(opciones[:page]).per(opciones[:limit])

    recibos = recibos.map{|m| [m.grupo, m.total]}.to_h
    caja_movimientos = caja_movimientos.map{|m| [m.grupo, m.total]}.to_h

    recibos.merge(caja_movimientos){|key, value_1, value_2| value_1 + value_2}
  end
end
