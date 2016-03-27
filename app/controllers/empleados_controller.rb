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
    get_empleados
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
      @message = "Se ha guardado el usuario"
      get_empleados
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el usuario. #{@empleado.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /empleados/1
  # PATCH/PUT /empleados/1.json
  def update
    if params[:empleado][:user_attributes][:password].blank? && params[:empleado][:user_attributes][:password_confirmation].blank?
      params[:empleado][:user_attributes].delete(:password)
      params[:empleado][:user_attributes].delete(:password_confirmation)
    end
    if @empleado.update(empleado_params)
      @error = false
      @message = "Se ha guardado el usuario"
      get_empleados
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el usuario. #{@empleado.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # DELETE /empleados/1
  # DELETE /empleados/1.json
  def destroy
    if @empleado.destroy
      @error = false
      @message = "Se ha eliminado el usuario"
      get_empleados
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el usuario"
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe el empleado con el nombre dado
  def check_nombre
    empleado = Empleado.by_nombre(params[:nombre]).first

    render json: (empleado.nil? || empleado.id == params[:id].to_i) ? true : t('empleado.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_empleados
    @search = Empleado.search(params[:q])
    @empleados = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empleado
      @empleado = Empleado.find(params[:id])
      @user = @empleado.user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empleado_params
      params.require(:empleado).permit(:nombre, :telefono, :direccion, :numero_documento, { user_attributes: [ :id, :username, :password, :password_confirmation] })
    end
end
