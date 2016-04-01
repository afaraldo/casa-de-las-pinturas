class WelcomeController < ApplicationController
  def index
  end

  def compras_index

  end

  def compras_form
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first)

  end
end
