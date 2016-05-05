class ReportesController < ApplicationController

  layout 'imprimir', only: [:imprimir_reporte_compras, :imprimir_reporte_gastos, :imprimir_reporte_ventas, :imprimir_reporte_caja]

  before_action :setup_menu, only: [:compras, :gastos, :ventas, :caja]
  before_action :setup_fechas

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :reportes
  end

  def compras
    @menu_setup[:side_menu] = :reporte_compras

    get_reporte_compras
    render 'reportes/compras/reporte'
  end

  def imprimir_reporte_compras
    get_reporte_compras
    render 'reportes/compras/imprimir_reporte'
  end

  def ventas
    @menu_setup[:side_menu] = :reporte_ventas

    get_reporte_ventas
    render 'reportes/ventas/reporte'
  end

  def imprimir_reporte_ventas
    get_reporte_ventas
    render 'reportes/ventas/imprimir_reporte'
  end

  def gastos
    @menu_setup[:side_menu] = :reporte_gastos

    get_reporte_gastos
    @categorias = CategoriaGasto.all
    render 'reportes/gastos/reporte'
  end

  def imprimir_reporte_gastos
    get_reporte_gastos
    render 'reportes/gastos/imprimir_reporte'
  end

  def caja
    @menu_setup[:side_menu] = :reporte_caja

    get_reporte_caja
    render 'reportes/caja/reporte'
  end

  def imprimir_reporte_caja
    get_reporte_caja
    render 'reportes/caja/imprimir_reporte'
  end

  def setup_fechas
    @desde = params[:fecha_desde].blank? ? DateTime.now.to_date.beginning_of_month : params[:fecha_desde].to_datetime.beginning_of_day
    @hasta = params[:fecha_hasta].blank? ? DateTime.now.to_date.end_of_month : params[:fecha_hasta].to_datetime.end_of_day
  end

  def get_reporte_compras
    @reporte = Compra.reporte(desde: @desde,
                              hasta: @hasta,
                              persona_id: params[:persona_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_compras' ? LIMITE_REGISTROS_IMPRIMIR : 100)
  end

  def get_reporte_ventas
    @reporte = Venta.reporte(desde: @desde,
                              hasta: @hasta,
                              persona_id: params[:persona_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_ventas' ? LIMITE_REGISTROS_IMPRIMIR : 100)
  end

  def get_reporte_gastos
    @reporte = CajaMovimiento.reporte_gastos(desde: @desde,
                              hasta: @hasta,
                              categoria_gasto_id: params[:categoria_gasto_id],
                              agrupar_por: params[:agrupar_por],
                              resumido: params[:modo_resumido].present?,
                              order_by: params[:order_by],
                              order_dir: params[:order_dir],
                              page: params[:page],
                              limit: action_name == 'imprimir_reporte_gastos' ? LIMITE_REGISTROS_IMPRIMIR : 100)
  end

  def get_reporte_caja

  end
end
