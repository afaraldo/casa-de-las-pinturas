class Venta < Boleta

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Cliente'
  delegate :nombre, to: :persona, prefix: true

end
