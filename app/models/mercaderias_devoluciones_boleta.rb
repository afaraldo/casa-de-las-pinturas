class MercaderiasDevolucionesBoleta < ActiveRecord::Base
  belongs_to :boleta
  belongs_to :notas_creditos_debito
end
