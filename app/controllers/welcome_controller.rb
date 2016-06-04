class WelcomeController < ApplicationController
  def index
    get_reporte

  end

  def setup_fechas
    @desde = params[:fecha_desde].blank? ? DateTime.now.to_date.beginning_of_month : params[:fecha_desde].to_datetime.beginning_of_day
    @hasta = params[:fecha_hasta].blank? ? DateTime.now.to_date.end_of_month : params[:fecha_hasta].to_datetime.end_of_day
  end

  def get_reporte
    @mercaderias = Mercaderia.all.count
    @saldo_en_caja =  Caja.get_caja_por_forma(:efectivo).saldos_total_en_moneda_por_defecto
    @reporte_compra = Compra.reporte(desde: @desde,
                              hasta: @hasta,
                              persona_id: params[:persona_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_compras' ? LIMITE_REGISTROS_IMPRIMIR : 100)

    @reporte_venta = Venta.reporte(desde: @desde,
                              hasta: @hasta,
                              persona_id: params[:persona_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_ventas' ? LIMITE_REGISTROS_IMPRIMIR : 100)
  end
end
