class ApplicationController < ActionController::Base
  include CustomNumberHelper

  layout :layout_by_resource

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!
  before_filter :set_menu_config
  protect_from_forgery with: :exception

  # Esta variable de instancia sse utilizara para saber que menus colocar como active y que submenus mostrar
  def set_menu_config
    @menu_setup = Hash.new
    @menu_setup[:main_menu] = nil
    @menu_setup[:side_menu] = nil
  end

  def layout_by_resource
  	if devise_controller?
  		"login"
  	else
  		"application"
  	end
  end
end
