class Compra < Boleta

  belongs_to :persona, -> { with_deleted }, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'

  has_many :recibos_detalles, class_name: 'PagoCompra', foreign_key: "boleta_id", inverse_of: :boleta
  has_many :recibos, dependent: :destroy, class_name: 'Pago', through: :recibos_detalles

  delegate :nombre, to: :persona, prefix: true

end
