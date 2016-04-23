class MercaderiasDevolucionesBoleta < ActiveRecord::Base
  belongs_to :boleta
  belongs_to :persona
end
