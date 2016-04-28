class Cliente < Persona
  has_many :ventas, foreign_key: 'persona_id'
  has_many :ventas_pendientes, -> { where(estado: :pendiente) }, class_name: 'Venta', foreign_key: 'persona_id'

  validates :nombre, presence: true, length: {maximum: 150, minimum: 2}, uniqueness: true
  validates :numero_documento, format: { with: /\d+-?\d+\z/, message: :only_numbers_is_allowed }
end
