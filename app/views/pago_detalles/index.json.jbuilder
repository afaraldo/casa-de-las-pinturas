json.array!(@pago_detalles) do |pago_detalle|
  json.extract! pago_detalle, :id, :pago_id, :forma, :monto, :moneda_id, :cotizacion
  json.url pago_detalle_url(pago_detalle, format: :json)
end
