json.array!(@pagos) do |pago|
  json.extract! pago, :id, :numero, :fecha, :total_efectivo, :total_tarjeta, :total_credito_utilizado, :tipo, :deleted_at
  json.url pago_url(pago, format: :json)
end
