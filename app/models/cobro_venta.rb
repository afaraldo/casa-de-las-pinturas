class CobroVenta < ReciboBoleta
  belongs_to :recibo, class_name: 'Cobro'
  belongs_to :boleta, class_name: 'Venta'
end
