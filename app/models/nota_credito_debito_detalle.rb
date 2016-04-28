class NotaCreditoDebitoDetalle < ActiveRecord::Base
  belongs_to :notas_creditos_debito
  belongs_to :mercaderia
end
