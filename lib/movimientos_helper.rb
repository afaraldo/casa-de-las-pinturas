module MovimientosHelper

  # def crear_movimiento(objeto)
  #   Movimiento.crear(objeto)
  # end
  #
  # class Movimiento
  #
  #   attr_reader :balances_class
  #
  #   def initialize(objeto)
  #     puts "*** INIT MODULE"
  #     @balances_class = self.balances.constantize
  #   end
  #
  #   def self.crear(objeto)
  #     mov = new(objeto)
  #   end
  # end

  def formatear_movimientos(movimientos)
    resultado = []

    movimientos.each do |m|
      case m.movimiento_tipo
        when 'MovimientoMercaderiaDetalle'
          detalle = m.movimiento_mercaderia_detalle
          es_ingreso = detalle.movimiento_mercaderia.tipo.ingreso?
          resultado << {fecha: detalle.movimiento_mercaderia.fecha, motivo: detalle.movimiento_mercaderia.motivo, ingreso: es_ingreso ? detalle.cantidad : 0, egreso: es_ingreso ? 0 : detalle.cantidad}
        else
          logger.info "No existe el tipo #{m.movimiento_tipo}"
      end
    end

    resultado
  end
end