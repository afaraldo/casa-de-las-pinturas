class Cliente < Persona

  validates :nombre, presence: true, length: {maximum: 150, minimum: 2}, uniqueness: true
  validates :numero_documento, format: { with: /\d+-?\d+\z/, message: :only_numbers_is_allowed }
end
