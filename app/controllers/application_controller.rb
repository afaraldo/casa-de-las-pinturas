class ApplicationController < ActionController::Base
  include CustomNumberHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_menu_config

  # Esta variable de instancia sse utilizara para saber que menus colocar como active y que submenus mostrar
  def set_menu_config
    @menu_setup = Hash.new
    @menu_setup[:main_menu] = nil
    @menu_setup[:side_menu] = nil
  end
end
