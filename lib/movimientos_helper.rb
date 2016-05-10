module MovimientosHelper

  def fecha_cambio_de_periodo?(fecha_nueva, fecha_anterior)
    diff_fecha =  (fecha_nueva.year * 12 + fecha_nueva.month) - (fecha_anterior.year * 12 + fecha_anterior.month)
    diff_fecha != 0
  end

  # Formatea los movimientos para mostrarlo en la vista
  # recibe un listado de Movimientos de Extractos
  # retorna un arreglo de hashes
  # [{url: url para acceder al movimiento,
  #   fecha: fecha del movimiento,
  #   motivo: el motivo del movimiento(compra, venta, movimiento, etc),
  #   ingreso: ingreso que corresponda,
  #   egreso: egreso que corresponda}, {}, ...]
  def formatear_movimientos(movimientos)

    resultados = []

    movimientos.each do |m|
      # Por cada tipo de movimiento se configura de manera adecuada el hash
      resultado = {}
      # Aca va cada movimiento
      case m.movimiento_tipo
        # -------------------------------
        # MOVIMIENTOS DE MERCADERIAS
        # -------------------------------
        when 'MovimientoMercaderiaDetalle'
          detalle = m.movimiento_mercaderia_detalle
          es_ingreso = detalle.movimiento_mercaderia.tipo.ingreso?
          resultado = {url: "/movimiento_mercaderias/#{detalle.movimiento_mercaderia.id}",
                        fecha: detalle.movimiento_mercaderia.fecha,
                        motivo: detalle.movimiento_mercaderia.motivo,
                        ingreso: es_ingreso ? detalle.cantidad : 0,
                        egreso: es_ingreso ? 0 : detalle.cantidad}
                        
        when 'BoletaDetalle'
          detalle = m.boleta_detalle
          es_ingreso = detalle.boleta.instance_of?(Compra)
          resultado = {url: "/#{es_ingreso ? 'compras' : 'ventas'}/#{detalle.boleta_id}",
                       fecha: detalle.boleta.fecha,
                       motivo: detalle.boleta.movimiento_motivo,
                       ingreso: es_ingreso ? detalle.cantidad : 0,
                       egreso: es_ingreso ? 0 : detalle.cantidad}

        when 'NotaCreditoDebitoDetalle'
          detalle = m.nota_credito_debito_detalle
          es_ingreso = !detalle.notas_creditos_debito.instance_of?(DevolucionCompra)
          resultado = {url: "/#{es_ingreso ? 'devolucion_compras' : 'devolucion_ventas'}/#{detalle.notas_creditos_debito_id}",
                       fecha: detalle.notas_creditos_debito.fecha,
                       motivo: detalle.notas_creditos_debito.movimiento_motivo,
                       ingreso: es_ingreso ? detalle.cantidad : 0,
                       egreso: es_ingreso ? 0 : detalle.cantidad}
        # -------------------------------
        # MOVIMIENTOS DE CUENTAS CORRIENTES - CLIENTES / PROVEEDORES
        # -------------------------------
        when 'Recibo'
          recibo = m.recibo
          resultado = {url: "/#{recibo.instance_of?(Pago) ? 'pagos' : 'cobros'}/#{recibo.id}",
                        fecha: recibo.fecha,
                        motivo: recibo.movimiento_motivo,
                        egreso: recibo.total_pagado,
                        ingreso: 0}

         when 'NotasCreditosDebito'
          notas_creditos_debito = m.notas_creditos_debito
          resultado = {url: "/#{notas_creditos_debito.instance_of?(DevolucionCompra) ? 'devolucion_compras' : 'devolucion_ventas'}/#{notas_creditos_debito.id}",
                        fecha: notas_creditos_debito.fecha,
                        motivo: notas_creditos_debito.movimiento_motivo,
                        egreso: notas_creditos_debito.importe_total,
                        ingreso: 0}

        when 'Boleta'
          boleta = m.boleta
          resultado = {url: "/#{boleta.instance_of?(Compra) ? 'compras' : 'ventas'}/#{boleta.id}",
                        fecha: boleta.fecha,
                        motivo: boleta.movimiento_motivo,
                        egreso: 0,
                        ingreso: boleta.importe_total}
        # -------------------------------
        # MOVIMIENTOS DE CAJA
        # -------------------------------
        when 'CajaMovimientoDetalle'
          detalle = m.caja_movimiento_detalle
          es_ingreso = detalle.caja_movimiento.tipo.ingreso?
          resultado = {url: "/caja_movimientos/#{detalle.caja_movimiento.id}",
                        fecha: detalle.caja_movimiento.fecha,
                        motivo: detalle.caja_movimiento.motivo,
                        ingreso: es_ingreso ? detalle.monto : 0,
                        egreso: es_ingreso ? 0 : detalle.monto}
        when 'ReciboDetalle'
          detalle = m.recibo_detalle
          es_ingreso = !detalle.recibo.instance_of?(Pago)
          resultado = {url: "/#{es_ingreso ? 'cobros' : 'pagos'}/#{detalle.recibo_id}",
                        fecha: detalle.recibo.fecha,
                        motivo: detalle.recibo.movimiento_motivo,
                        ingreso: es_ingreso ? detalle.monto : 0,
                        egreso: es_ingreso ? 0 : detalle.monto}
        else
          logger.info "No existe el tipo #{m.movimiento_tipo}"
      end
      resultado[:movimiento_id] = m.id
      resultados << resultado
    end

    resultados
  end

end