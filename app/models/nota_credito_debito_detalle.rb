class NotaCreditoDebitoDetalle < ActiveRecord::Base
  belongs_to :notas_creditos_debito
  belongs_to :mercaderia
  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true
end
