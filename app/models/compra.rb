class Compra < Boleta

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'#, counter_cache: true
  delegate :nombre, to: :persona, prefix: true

  has_many :pagos_detalles, class_name: 'ReciboBoleta', foreign_key: "recibo_id", dependent: :restrict_with_error, inverse_of: :boleta
  has_many :pagos, class_name: 'Pago', dependent: :restrict_with_error, through: :pagos_detalles, source: 'recibo'
end
