class Compra < Boleta
  belongs_to :proveedor, foreign_key: "persona_id"
end
