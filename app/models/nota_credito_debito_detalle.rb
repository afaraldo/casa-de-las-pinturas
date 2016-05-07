class NotaCreditoDebitoDetalle < ActiveRecord::Base
  belongs_to :notas_creditos_debito
  belongs_to :mercaderia
  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true
  validates :cantidad, numericality: { greater_than: 0, less_than_or_equal_to: DECIMAL_LIMITE[:superior] }
 
end
