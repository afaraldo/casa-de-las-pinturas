module ApplicationHelper
  include MovimientosHelper

  TEXTO_LIMITE = 30 # longitud maxima mostrar de los textos

  # Metodo para cortar los textos a mostrar en las tablas.
  # Se agrega un popover al texto si es necesario
  def cortar_texto(texto)
    html = ""
    html << "<div class='on-hover' data-toggle='popover' data-placement='top' data-content='#{texto}'>" if texto.size > TEXTO_LIMITE
      html << truncate(texto, length: TEXTO_LIMITE, separator: ' ')
    html << '</div>' if texto.size > TEXTO_LIMITE
    html.html_safe
  end

  # metodo para determinar si se esta mostarndo los ultimos movimientos de algun extracto
  def ultimos_movimientos?
    @desde.nil? || @hasta.nil?
  end

  def editar_btn(objeto, url)
    editable = objeto.es_editable?

    url = '#' unless editable

    html = ''
    html << "<div class='btn-wrap' data-toggle='tooltip' title='#{objeto.no_editable_mensaje}'>" unless editable
      html << link_to('<i class="fa fa-edit"></i> Editar'.html_safe, url, class: "btn btn-default #{'disabled' unless editable}")
    html << '</div>' unless editable

    html.html_safe
  end

  def eliminar_btn(objeto, url, confirm)
    eliminable = objeto.es_eliminable?

    url = '#' unless eliminable

    html = ''
    html << "<div class='btn-wrap' data-toggle='tooltip' title='#{objeto.no_eliminable_mensaje}'>" unless eliminable
      html << link_to('<i class="fa fa-trash"></i> Eliminar'.html_safe, url, method: :delete, data: { confirm: confirm }, class: "btn btn-danger #{'disabled' unless eliminable}")
    html << '</div>' unless eliminable

    html.html_safe
  end

end
