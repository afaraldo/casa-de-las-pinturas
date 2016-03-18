class Moneda < ActiveRecord::Base
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 45, minimum: 2}
  validates :nombre, uniqueness: true
  validates :nombre, format: { with: /\A[a-zA-Z]+\z/, message: :only_letters_is_allowed }
  validates :cotizacion, presence: true
  validates :cotizacion, numericality: { less_than_or_equal_to: 999999999999999, greater_than_or_equal_to: 0 }
  validates :abreviatura, presence: true
  validates :abreviatura, length: {maximum: 5, minimum: 1}
  validates :abreviatura, uniqueness: true
end
