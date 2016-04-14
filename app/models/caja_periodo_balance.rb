class CajaPeriodoBalance < ActiveRecord::Base
  belongs_to :caja
  belongs_to :moneda
end
