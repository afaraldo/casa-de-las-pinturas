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

end
