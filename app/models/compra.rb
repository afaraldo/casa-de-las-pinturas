class Compra < Boleta

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'#, counter_cache: true
  delegate :nombre, to: :persona, prefix: true

  has_many :recibos_detalles, foreign_key: "recibo_id", inverse_of: :boleta, dependent: :restrict_with_error, class_name: 'ReciboBoleta'
  has_many :recibos, class_name: 'Pago', dependent: :restrict_with_error, through: :pagos_detalles
end
