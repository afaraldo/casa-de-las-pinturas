class Venta < Boleta

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Cliente'

  has_many :recibos_detalles, class_name: 'CobroVenta', foreign_key: "boleta_id", inverse_of: :boleta
  has_many :recibos, dependent: :destroy, class_name: 'Cobro', through: :recibos_detalles

  delegate :nombre, to: :persona, prefix: true

end
