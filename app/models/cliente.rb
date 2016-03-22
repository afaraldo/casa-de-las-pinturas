class Cliente < Persona
  validates :nombre, presence: true, length: {maximum: 150, minimum: 2}, uniqueness: true
end
