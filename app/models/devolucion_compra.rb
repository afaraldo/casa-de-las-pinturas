class DevolucionCompra < NotasCreditosDebito
  belongs_to :persona, -> { with_deleted }, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'#, counter_cache: true
  delegate :nombre, to: :persona, prefix: true
end
