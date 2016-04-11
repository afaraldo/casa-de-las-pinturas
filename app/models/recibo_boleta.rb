class ReciboBoleta < ActiveRecord::Base
  belongs_to :recibo
  belongs_to :boleta
end
