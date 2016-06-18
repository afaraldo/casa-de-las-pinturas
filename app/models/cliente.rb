class Cliente < Persona
  has_many :ventas, foreign_key: 'persona_id'
  has_many :ventas_pendientes, -> { where(estado: :pendiente) }, class_name: 'Venta', foreign_key: 'persona_id'

  has_many :devoluciones_disponibles, -> { where.not(credito_restante: 0) }, class_name: 'NotasCreditosDebito', foreign_key: 'persona_id'

  validates :nombre, presence: true, length: {maximum: 150, minimum: 2}, uniqueness: true
  validates :numero_documento, format: { with: /\d+-?\d+\z/, message: :only_numbers_is_allowed }
  before_destroy :tiene_deuda?

  def tiene_deuda?
    if saldo_actual == 0
      true
    else
        errors.add(:base, "El cliente tiene operaciones pendientes")
        false
    end
  end
end
