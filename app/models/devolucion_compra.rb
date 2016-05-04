class DevolucionCompra < NotasCreditosDebito

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :boletas, class_name: 'Proveedor'#, counter_cache: true
  belongs_to :boletas_detalles, foreign_key: "boleta_detalle_id" 
  delegate :nombre, to: :persona, prefix: true
  delegate :numero, to: :compra, prefix: true

end
