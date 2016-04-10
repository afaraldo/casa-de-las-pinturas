class BoletaDetalle < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :boleta, inverse_of: :detalles
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true
end
