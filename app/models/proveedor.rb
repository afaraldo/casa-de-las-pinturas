class Proveedor < Persona

  has_many :compras
  has_many :compras_pendientes, -> { where(estado: :pendiente) }, class_name: 'Compra', foreign_key: 'persona_id'

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :nombre, uniqueness: true

end
