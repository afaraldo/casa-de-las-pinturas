class InventariosController < ApplicationController
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :stock
    @menu_setup[:side_menu] = :inventario_sidemenu
  end

  def index
    get_mercaderias
    get_categorias
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

end