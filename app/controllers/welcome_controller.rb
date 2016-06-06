class WelcomeController < ApplicationController
  def index
    setup_fechas
    get_reporte
  end

  def setup_fechas
    @desde = params[:fecha_desde].blank? ? DateTime.now.to_date.beginning_of_month : params[:fecha_desde].to_datetime.beginning_of_day
    @hasta = params[:fecha_hasta].blank? ? DateTime.now.to_date.end_of_month : params[:fecha_hasta].to_datetime.end_of_day
  end

  def get_reporte
    @mercaderias = Mercaderia.cantidad_total_de_existencias
    @saldo_en_caja =  Caja.get_caja_por_forma(:efectivo).saldos_total_en_moneda_por_defecto
    @saldo_total_clientes = Persona.saldo_total "clientes"
    @saldo_total_proveedores = Persona.saldo_total "proveedores"
    @total_venta_contado = Boleta.importe_total_boletas(@desde, @hasta, "Venta", "contado")
    @total_venta_credito = Boleta.importe_total_boletas(@desde, @hasta, "Venta", "credito")
    @total_compra_contado = Boleta.importe_total_boletas(@desde, @hasta, "Compra", "contado")
    @total_compra_credito = Boleta.importe_total_boletas(@desde, @hasta, "Compra", "credito")
    params[:order_by]= "grupo"
    params[:order_dir]= "asc"
    params[:persona_id]= ""
    params[:agrupar_por]= "dia"
    params[:modo_resumido]= "on"
    @reporte = Boleta.reporte_mensual(desde: @desde,
                              hasta: @hasta,
                              persona_id: params[:persona_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_compras' ? LIMITE_REGISTROS_IMPRIMIR : 100)

  end
end
