class WelcomeController < ApplicationController
  def index
  end

  def compras_index

  end

  def compras_form
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 23)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 2)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 10)

  end

  def compras_reporte

  end

  def reporte_ventas_index

  end
end
