module CustomNumberHelper
  # recibe una cantidad enmascarada y retorna el numero correspondiente
  # Ej.: 1.200,3 a 1200.3
  def cantidad_a_numero(cantidad)
    cantidad.to_s.gsub(/[.]/,'').gsub(/[,]/,'.').to_f
  end
end