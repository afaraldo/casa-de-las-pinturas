class MercaderiasController < ApplicationController
  before_action :set_mercaderia, only: [:edit, :update, :destroy]
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :stock
    @menu_setup[:side_menu] = :mercaderias_sidemenu
  end

  def index
    get_mercaderias
    get_categorias
  end

  def new
    @mercaderia = Mercaderia.new
    render 'load_form', format: :js
  end

  def edit
    render 'load_form', format: :js
  end

  def create
    @mercaderia = Mercaderia.new(mercaderia_params)

    if @mercaderia.save
      @error = false
      @message = t('mensajes.save_success', recurso: 'la mercadería')
      get_mercaderias
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la mercadería', errores: @mercaderia.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  def update

    if @mercaderia.update(mercaderia_params)
      @error = false
      @message = t('mensajes.save_success', recurso: 'la mercadería')
      get_mercaderias
    else
      @error = true
      @message = t('mensajes.save_error', recurso: 'la mercadería', errores: @mercaderia.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  def destroy
    if @mercaderia.destroy
      @error = false
      @message = t('mensajes.delete_success', recurso: 'la mercadería')
      get_mercaderias
    else
      @error = true
      @message = t('mensajes.delete_error', recurso: 'la mercadería', errores: @mercaderia.errors.full_messages.to_sentence)
    end

    render 'reload_list', format: :js
  end

  # Comprobar si ya existe una mercaderia con el codigo dado
  def check_codigo
    mercaderia = Mercaderia.by_codigo(params[:codigo]).first

    render json: (mercaderia.nil? || mercaderia.id == params[:id].to_i) ? true : t('mercaderia.unique_codigo_error', codigo: params[:codigo]).to_json
  end

  def get_categorias
    @search = Categoria.padres.search(params[:q])
    @categorias = @search.result.page(params[:page])
  end

  def get_mercaderias
    # incluir subcategorias se se selecciona una categoria padre
    if params[:q].present? && params[:q][:categoria_id_eq_any].present?
      categoria = Categoria.find(params[:q][:categoria_id_eq_any])
      if categoria.categoria_padre_id.nil?
        params[:q][:categoria_id_eq_any] = [categoria.id] + categoria.subcategorias.ids
      end
    end

    @search_mercaderias = Mercaderia.search(params[:q])
    @mercaderias = @search_mercaderias.result.page(params[:page])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_mercaderia
    @mercaderia = Mercaderia.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mercaderia_params
    procesar_cantidades
    params.require(:mercaderia).permit(:codigo, :nombre, :categoria_id, :costo,
                                       :unidad_de_medida, :precio_venta_contado, :stock, :stock_minimo,
                                       :precio_venta_credito, :descripcion)
  end

  # reemplazar las comas por puntos en el caso de las cantidades decimales
  def procesar_cantidades
    params[:mercaderia][:stock] = cantidad_a_numero(params[:mercaderia][:stock])
    params[:mercaderia][:stock_minimo] = cantidad_a_numero(params[:mercaderia][:stock_minimo])
  end
end
