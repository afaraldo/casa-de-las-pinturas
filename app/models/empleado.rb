class Empleado < Persona
  accepts_nested_attributes_for :user
  validates_presence_of :user
  validates_associated :user
  validates_uniqueness_of :nombre, allow_blank: false
end
