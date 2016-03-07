class Persona < ActiveRecord::Base
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 40}
  validates :telefono, length: {maximum: 20}
  validates :direccion, length: {maximum: 200}
  validates :ruc, length: {maximum: 30}
end
