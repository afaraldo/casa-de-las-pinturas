class CategoriaGastosController < ApplicationController
  before_action :set_categoria_gasto, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :categoria_gastos
    @menu_setup[:side_menu] = :categoria_gastos_sidemenu
  end

  # GET /categoria_gastos
  # GET /categoria_gastos.json
  def index
    get_categoria_gastos
  end

  # GET /categoria_gastos/1
  # GET /categoria_gastos/1.json
  def show
  end

  # GET /categoria_gastos/new
  def new
    @categoria_gasto = CategoriaGasto.new
    render 'load_form', format: :js
  end

  # GET /categoria_gastos/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /categoria_gastos
  # POST /categoria_gastos.json
  def create
    @categoria_gasto = CategoriaGasto.new(categoria_gasto_params)

    if @categoria_gasto.save
      @error = false
      @message = t('mensajes.save_success', recurso: 'la categoria')
      get_categoria_gastos
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la categoria', errores: @categoria_gasto.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /categoria_gastos/1
  # PATCH/PUT /categoria_gastos/1.json
  def update
    if @categoria_gasto.update(categoria_gasto_params)
      @error = false
      @message = t('mensajes.save_success', recurso: 'la categoria')
      get_categoria_gastos
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la categoria', errores: @categoria_gasto.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # DELETE /categoria_gastos/1
  # DELETE /categoria_gastos/1.json
  def destroy
    if @categoria_gasto.destroy
      @error = false
      @message = t('mensajes.delete_success', recurso: 'la categoria')
      get_categoria_gastos
    else
      @error = true
      @message = t('mensajes.delete_error', recurso: 'la categoria', errores: @categoria_gasto.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  def check_nombre
    categoria_gasto = CategoriaGasto.by_nombre(params[:nombre]).first

    render json: (categoria_gasto.nil? || categoria_gasto.id == params[:id].to_i) ? true : t('categoria_gasto.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_categoria_gastos
    # si la llamada es desde el buscador incluir las subcategorias tambien
    @search = CategoriaGasto.search(params[:q])
    @categoria_gastos = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categoria_gasto
      @categoria_gasto = CategoriaGasto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def categoria_gasto_params
      params.require(:categoria_gasto).permit(:nombre)
    end
end
