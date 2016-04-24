class ReportesController < ApplicationController

  before_action :setup_menu, only: [:compras]
  before_action :setup_fechas, only: [:compras]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :reported
  end

  def compras
    @menu_setup[:side_menu] = :reporte_compras

    @reporte = Compra.get_reporte(@desde, @hasta, params[:persona_id], params[:agrupar_por], params[:modo_resumido].present?)
  end


  def setup_fechas
    @desde = params[:fecha_desde].blank? ? DateTime.now.beginning_of_month : params[:fecha_desde]
    @hasta = params[:fecha_hasta].blank? ? DateTime.now.end_of_month : params[:fecha_hasta]
  end
end
