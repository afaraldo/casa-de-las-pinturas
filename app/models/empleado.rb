class Empleado < Persona
  validates_uniqueness_of :nombre, allow_blank: false
end
