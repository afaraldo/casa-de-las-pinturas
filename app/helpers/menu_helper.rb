require 'yaml'

module MenuHelper

  # Se arma una lista de <li> de acuerdo a los datos del menus.yml
  def main_menu
    menu = MENU_DATA['menu']
    html = ""

    menu.each do |item, opciones|
      active = is_active_main_menu?(opciones['active_menu'])
      html << content_tag(:li, link_to(opciones['text'], opciones['url']), class: active ? 'active' : '')
    end

    html.html_safe
  end

  def is_active_main_menu?(active_indicator)
    @menu_setup[:main_menu] == active_indicator
  end

  # Listado de submenus para cada seccion
  def side_menu
    items = MENU_DATA['menu'][@menu_setup[:main_menu].to_s]['submenus']
    html = ""

    items.each do |item, opciones|
      active = is_active_side_menu?(opciones['active_submenu'])
      html << content_tag(:li, link_to((opciones['text'] + (active ? ' <i class="fa fa-angle-right pull-right"></i>' : '')).html_safe, opciones['url']), class: active ? 'active' : '')
    end

    html.html_safe
  end

  def is_active_side_menu?(active_indicator)
    @menu_setup[:side_menu] == active_indicator
  end

end