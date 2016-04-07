require 'yaml'

module MenuHelper

  # Se arma una lista de <li> de acuerdo a los datos del menus.yml
  def main_menu
    menu = MENU_DATA['menu']
    html = ""

    menu.each do |item, opciones|
      active = is_active_main_menu?(opciones['active_menu'])
      html << "<li class='dropdown #{active ? 'active' : ''}'>"
        html << link_to((opciones['text'] + '<span class="caret"></span>').html_safe, '#', class: 'dropdown-toggle')
        html << build_submenus(opciones['submenus'])
      html << "</li>"
    end

    html.html_safe
  end

  def build_submenus(submenus)
    html = "<ul class='dropdown-menu'>"

    submenus.each do |item, opciones|
      active = is_active_submenu_menu?(opciones['active_submenu'])
      html << content_tag(:li, link_to(opciones['text'], opciones['url']), class: active ? 'active' : '')
    end

    html << "</ul>"

    html.html_safe
  end

  def is_active_main_menu?(active_indicator)
    @menu_setup[:main_menu] == active_indicator
  end

  def is_active_submenu_menu?(active_indicator)
    @menu_setup[:side_menu] == active_indicator
  end

end