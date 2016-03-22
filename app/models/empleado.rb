class Empleado < Persona
  accepts_nested_attributes_for :user
  validates_presence_of :user
  validates_associated :user
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :nombre, uniqueness: true
end
