json.array!(@boletas) do |boleta|
  json.extract! boleta, :id, :persona_id, :numero, :numero_factura, :fecha, :fecha_vencimiento, :estado, :tipo, :condicion, :importe_total, :importe_pendiente, :importe_descontado
  json.url boleta_url(boleta, format: :json)
end
