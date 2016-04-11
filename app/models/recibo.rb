class Recibo < ActiveRecord::Base

  acts_as_paranoid

  self.inheritance_column = 'tipo'

end
