class EmpleadosController < ApplicationController
  before_action :set_empleado, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :configuraciones
    @menu_setup[:side_menu] = :empleados_sidemenu
  end

  # GET /empleados
  # GET /empleados.json
  def index
    @empleados = Empleado.all
  end

  # GET /empleados/1
  # GET /empleados/1.json
  def show
  end

  # GET /empleados/new
  def new
    @empleado = Empleado.new
    @user = @empleado.build_user
    render 'load_form', format: :js
  end

  # GET /empleados/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /empleados
  # POST /empleados.json
  def create
    @empleado = Empleado.new(empleado_params)
    if @empleado.save
      @error = false
      @message = "Se ha guardado el empleado"
      @empleados = Empleado.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el empleado. #{@empleado.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /empleados/1
  # PATCH/PUT /empleados/1.json
  def update
    if @empleado.update(empleado_params)
      @error = false
      @message = "Se ha guardado el empleado"
      @empleados = Empleado.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el empleado. #{@empleado.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # DELETE /empleados/1
  # DELETE /empleados/1.json
  def destroy
    if @empleado.destroy
      @error = false
      @message = "Se ha eliminado el empleado"
      @empleados = Empleado.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el empleado"
    end

    render 'reload_list', format: :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empleado
      @empleado = Empleado.find(params[:id])
      @user = @empleado.user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empleado_params
      params.require(:empleado).permit(:nombre, :telefono, :direccion, :numero_documento, { user_attributes: [ :id, :username, :email, :password, :password_confirmation] })
    end
end
