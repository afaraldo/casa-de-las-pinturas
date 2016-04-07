class Empleado < Persona
  accepts_nested_attributes_for :user
  validates_presence_of :user
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :nombre, uniqueness: true
  validates :numero_documento, format: { with: /\A(\d+[.]*[ ]*-?)+\z/, message: :only_numbers_is_allowed }, allow_blank: false
  delegate :username, :rol, to: :user, prefix: true
end
