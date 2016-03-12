class MercaderiasController < ApplicationController
  before_action :setup_menu, only: [:index]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :stock
    @menu_setup[:side_menu] = :mercaderias_sidemenu
  end

  def index
    get_categorias
  end

  def get_categorias
    @search = Categoria.padres.search(params[:q])
    @categorias = @search.result.page(params[:page])
  end

end
