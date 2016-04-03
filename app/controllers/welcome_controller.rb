class WelcomeController < ApplicationController
  def index
  end

  def compras_index

  end

  def compras_show

  end

  def compras_show_credito
    
  end

  def compras_form
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 23)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 2)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 10)

  end
  def devoluciones_venta
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 23)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 2)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 10)

  end
  def devoluciones_compra
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 23)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 2)
    @movimiento.detalles.build(mercaderia: Mercaderia.offset(rand(Mercaderia.count)).first, cantidad: 10)

  end

  def devoluciones_venta_index

  end
  def devoluciones_compra_index

  end

  def compras_reporte

  end

  def reporte_ventas_index

  end

  def gastos_reporte

  end
end
