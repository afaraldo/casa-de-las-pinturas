json.array!(@boleta_detalles) do |boleta_detalle|
  json.extract! boleta_detalle, :id, :boleta_id, :mercaderia_id, :cantidad, :precio_unitario
  json.url boleta_detalle_url(boleta_detalle, format: :json)
end
