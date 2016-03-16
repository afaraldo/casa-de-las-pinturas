class MovimientoMercaderiaDetalle < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :movimiento_mercaderia
  belongs_to :mercaderia

end
