class Pago < Recibo
  belongs_to :proveedor, foreign_key: 'persona_id'

  delegate :nombre, to: :proveedor, prefix: true
end
