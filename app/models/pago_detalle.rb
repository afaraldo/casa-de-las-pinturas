class PagoDetalle < ActiveRecord::Base
  belongs_to :pago
  belongs_to :moneda
end
