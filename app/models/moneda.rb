class Moneda < ActiveRecord::Base
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 45, minimum: 2}
  validates :nombre, uniqueness: true
  validates :cotizacion, presence: true
  validates :cotizacion, numericality: true

end
