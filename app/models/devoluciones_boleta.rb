class DevolucionesBoleta < ActiveRecord::Base
  acts_as_paranoid
  self.table_name = 'devoluciones_boleta'
  belongs_to :boleta
  belongs_to :notas_creditos_debito

end
