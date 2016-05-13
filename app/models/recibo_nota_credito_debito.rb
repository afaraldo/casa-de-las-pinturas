class ReciboNotaCreditoDebito < ActiveRecord::Base
  belongs_to :recibo
  belongs_to :notas_creditos_debito
end
