class ReciboDetalle < ActiveRecord::Base
  extend Enumerize

  belongs_to :recibo
  belongs_to :moneda

  enumerize :forma, in: [:efectivo, :tarjeta], predicates: true

end
