class ReciboBoleta < ActiveRecord::Base
  self.table_name = 'recibos_boletas'

  belongs_to :recibo
  belongs_to :boleta

end
