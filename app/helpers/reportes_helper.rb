module ReportesHelper

  def ventas_grupos
    [['Cliente', 'persona'], ['Día', 'dia'], ['Mes', 'month'], ['Año', 'year']]
  end

  def gastos_grupos
    [['Categoría', 'categoria'], ['Día', 'dia'], ['Mes', 'month'], ['Año', 'year']]
  end

  def caja_grupos
    [['Día', 'dia'], ['Mes', 'month'], ['Año', 'year']]
  end

  def compras_grupos
    [['Proveedor', 'persona'], ['Día', 'dia'], ['Mes', 'month'], ['Año', 'year']]
  end

  def agrupado_por_titulo(agrupado_por)
    case agrupado_por
      when 'month'
        'Mes'
      when 'year'
        'Año'
      when 'persona'
        'Proveedor'
      when 'categoria'
        'Categoría'
      else
        'Día'
    end
  end

  def grupo_label(grupo, agrupado_por)
    case agrupado_por
      when 'dia'
        localize(grupo.to_date)
      when 'month'
        get_mes_anho(grupo).capitalize
      else
        grupo
    end
  end

  def get_mes_anho(mes_anho)
    data = mes_anho.split('-')
    "#{t('date.month_names')[data[1].to_i]}, #{data[0]}"
  end

  def order_reporte_link(texto, order_by)
    order_dir = params[:order_dir] || 'asc'
    html = ''
    html << "<a class='ordenar-link' href='#' data-order-by='#{order_by}' data-order-dir='#{params[:order_by] == order_by ? (order_dir == 'asc' ? 'desc' : 'asc') : 'asc'}'>"
      html << texto

    if params[:order_by] == order_by
      html << "<i class='fa fa-sort-amount-#{order_dir}'></i>"
    end

    html << '</a>'

    html.html_safe
  end
end
