class Proveedor < Persona

  has_many :compras, foreign_key: 'persona_id'
  has_many :compras_pendientes, -> { where(estado: :pendiente) }, class_name: 'Compra', foreign_key: 'persona_id'

  has_many :devoluciones_disponibles, -> { where.not(credito_restante: 0) }, class_name: 'NotasCreditosDebito', foreign_key: 'persona_id'

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :nombre, uniqueness: true
  before_destroy :tiene_deuda?

  def tiene_deuda?
    if saldo_actual == 0
      true
    else
        errors.add(:base, "El proveedor tiene operaciones pendientes")
        false
    end
  end
end
