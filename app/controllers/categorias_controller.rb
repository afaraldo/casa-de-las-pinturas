class CategoriasController < ApplicationController
  before_action :set_categoria, only: [:show, :edit, :update, :destroy]

  # GET /categoria
  # GET /categoria.json
  def index
    get_categorias
  end

  # GET /categoria/1
  # GET /categoria/1.json
  def show
  end

  # GET /categoria/new
  def new
    @categoria = Categoria.new
    render 'load_form', format: :js
  end

  # GET /categoria/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /categoria
  # POST /categoria.json
  def create
    @categoria = Categoria.new(categoria_params)

    if @categoria.save
      @error = false
      @message = t('mensajes.save_success', recurso: 'la categoria')
      get_categorias
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la categoria', errores: @categoria.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /categoria/1
  # PATCH/PUT /categoria/1.json
  def update

    if @categoria.update(categoria_params)
      @error = false
      @message = t('mensajes.save_success', recurso: 'la categoria')
      get_categorias
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la categoria', errores: @categoria.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # DELETE /categoria/1
  # DELETE /categoria/1.json
  def destroy
    if @categoria.destroy
      @error = false
      @message = t('mensajes.delete_success', recurso: 'la categoria')
      get_categorias
    else
      @error = true
      @message = t('mensajes.delete_error', recurso: 'la categoria', errores: @categoria.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe el proveedor con el nombre dado
  def check_nombre
    categoria = Categoria.by_nombre(params[:nombre]).first

    render json: (categoria.nil? || categoria.id == params[:id].to_i) ? true : t('categoria.unique_nombre_error', nombre: params[:nombre]).to_json
  end

  def get_categorias
    @search = Categoria.padres.search(params[:q])
    @categorias = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categoria
      @categoria = Categoria.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def categoria_params
      params.require(:categoria).permit(:nombre, :categoria_padre_id)
    end
end
