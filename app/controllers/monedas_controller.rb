class MonedasController < ApplicationController
  before_action :set_moneda, only: [:show, :edit, :update, :destroy]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :cajas
    @menu_setup[:side_menu] = :monedas_sidemenu
  end

  # GET /monedas
  # GET /monedas.json
  def index
    get_monedas
  end

  # GET /monedas/1
  # GET /monedas/1.json
  def show
  end

  # GET /monedas/new
  def new
    @moneda = Moneda.new
    render 'load_form', format: :js
  end

  # GET /monedas/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /monedas
  # POST /monedas.json
  def create
    @moneda = Moneda.new(moneda_params)

    if @moneda.save
      @error = false
      @message = "Se ha guardado el moneda"
      get_monedas
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el moneda. #{@moneda.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /monedas/1
  # PATCH/PUT /monedas/1.json
  def update
    if @moneda.update(moneda_params)
      @error = false
      @message = "Se ha guardado el moneda"
      get_monedas
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el moneda. #{@moneda.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # DELETE /monedas/1
  # DELETE /monedas/1.json
  def destroy
    @moneda.destroy
    if @moneda.destroy
      @error = false
      @message = "Se ha eliminado el moneda"
      get_monedas
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el moneda"
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe una moneda con el nombre dado
  def check_nombre
    moneda = Moneda.by_nombre(params[:nombre]).first

    render json: (moneda.nil? || moneda.id == params[:id].to_i) ? true : t('moneda.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_monedas
    @search = Moneda.search(params[:q])
    @monedas = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moneda
      @moneda = Moneda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moneda_params
      params.require(:moneda).permit(:nombre, :abreviatura, :cotizacion)
    end
end
