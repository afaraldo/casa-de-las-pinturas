class MercaderiasDevolucionesBoleta < ActiveRecord::Base
  
  acts_as_paranoid

  self.table_name = 'mercaderias_devoluciones_boletas'
  belongs_to :boleta
  belongs_to :notas_creditos_debito

end
