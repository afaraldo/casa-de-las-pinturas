class BoletaDetalle < ActiveRecord::Base
  belongs_to :boleta
  belongs_to :mercaderia
end
