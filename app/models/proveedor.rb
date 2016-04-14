class Proveedor < Persona
  has_many :boletas, foreign_key: 'persona_id', inverse_of: :persona, class_name: 'Compra'

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :nombre, uniqueness: true
end
