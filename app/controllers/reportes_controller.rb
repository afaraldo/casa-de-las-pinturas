class ReportesController < ApplicationController

  layout 'imprimir', only: [:imprimir_reporte_compras]

  before_action :setup_menu, only: [:compras]
  before_action :setup_fechas

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :reported
  end

  def compras
    @menu_setup[:side_menu] = :reporte_compras

    get_reporte_compras
  end

  def imprimir_reporte_compras
    get_reporte_compras
  end

  def setup_fechas
    @desde = params[:fecha_desde].blank? ? DateTime.now.beginning_of_month : params[:fecha_desde].to_datetime.beginning_of_day
    @hasta = params[:fecha_hasta].blank? ? DateTime.now.end_of_month : params[:fecha_hasta].to_datetime.end_of_day
  end

  def get_reporte_compras
    @reporte = Compra.get_reporte(@desde, @hasta,
                                  params[:persona_id], params[:agrupar_por],
                                  params[:modo_resumido].present?, params[:page],
                                  action_name == 'imprimir_reporte_compras' ? LIMITE_REGISTROS_IMPRIMIR : 100)
  end
end
