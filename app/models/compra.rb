class Compra < Boleta
  belongs_to :proveedor, foreign_key: "persona_id"
  delegate :nombre, to: :proveedor, prefix: true

  def numero
    id
  end
end
