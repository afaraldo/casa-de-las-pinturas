class PagoCompra < ReciboBoleta
  belongs_to :recibo, class_name: 'Pago'
  belongs_to :boleta, class_name: 'Compra'
end
