class CajaSaldo < ActiveRecord::Base
  belongs_to :Caja
  belongs_to :moneda
end
