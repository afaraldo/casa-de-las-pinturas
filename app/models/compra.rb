class Compra < Boleta

  belongs_to :proveedor, foreign_key: "persona_id"
  delegate :nombre, to: :proveedor, prefix: true

  has_many :pagos_detalles, class_name: 'ReciboBoleta', foreign_key: "boleta_id", dependent: :restrict_with_error, inverse_of: :boleta
  has_many :pagos, class_name: 'Pago', dependent: :restrict_with_error, through: :pagos_detalles, source: 'recibo'
end
