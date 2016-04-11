class ReciboDetalle < ActiveRecord::Base
  belongs_to :recibo
  belongs_to :moneda
end
