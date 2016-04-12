module MovimientosHelper

  # Formatea los movimientos para mostrarlo en la vista
  # recibe un listado de Movimientos de Extractos
  # retorna un arreglo de hashes
  # [{url: url para acceder al movimiento,
  #   fecha: fecha del movimiento,
  #   motivo: el motivo del movimiento(compra, venta, movimiento, etc),
  #   ingreso: ingreso que corresponda,
  #   egreso: egreso que corresponda}, {}, ...]
  def formatear_movimientos(movimientos)

    resultado = []

    movimientos.each do |m|
      # Por cada tipo de movimiento se configura de manera adecuada el hash

      # Aca va cada movimiento
      case m.movimiento_tipo
        when 'MovimientoMercaderiaDetalle'
          detalle = m.movimiento_mercaderia_detalle
          es_ingreso = detalle.movimiento_mercaderia.tipo.ingreso?
          resultado << {url: "/movimiento_mercaderia/#{detalle.movimiento_mercaderia.id}",
                        fecha: detalle.movimiento_mercaderia.fecha,
                        motivo: detalle.movimiento_mercaderia.motivo,
                        ingreso: es_ingreso ? detalle.cantidad : 0,
                        egreso: es_ingreso ? 0 : detalle.cantidad}
        else
          logger.info "No existe el tipo #{m.movimiento_tipo}"
      end
    end

    resultado
  end

end