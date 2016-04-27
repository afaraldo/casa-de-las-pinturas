module ReportesHelper

  def agrupado_por_titulo(agrupado_por)
    case agrupado_por
      when 'month'
        'Mes'
      when 'year'
        'Año'
      when 'persona'
        'Proveedor'
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
end
