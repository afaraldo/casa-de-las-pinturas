class Compra < Boleta

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'

  has_many :recibos, class_name: 'Pago', dependent: :destroy, through: :recibos_detalles

  delegate :nombre, to: :persona, prefix: true

end
