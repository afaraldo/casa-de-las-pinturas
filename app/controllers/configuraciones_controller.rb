class ConfiguracionesController < ApplicationController
  before_action :set_configuracion, only: [:edit, :update]
  before_action :setup_menu, only: [:index, :edit, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :configuraciones
    @menu_setup[:side_menu] = :datos_empresa_sidemenu
  end

  # GET /configuraciones/1/edit
  def edit
  end

  def index

    redirect_to edit_configuracion_path(Configuracion.first)

  end

  # PATCH/PUT /configuraciones/1
  # PATCH/PUT /configuraciones/1.json
  def update
    @configuracion = Configuracion.find(params[:id])
    respond_to do |format|
      if @configuracion.update_attributes(configuracion_params)
        flash.now[:notice] = "Configuraciones actualizadas correctamente"
        format.html { render "edit"}
      else
        flash.now[:error] = "Ha ocurrido un problema al tratar de guardar la configuracion"
        format.html { render "edit"}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configuracion
      @configuracion = Configuracion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def configuracion_params
      params.require(:configuracion).permit(:empresa_nombre, :logo, :empresa_direccion, :empresa_telefono, :empresa_email,:avatar)
    end
end
