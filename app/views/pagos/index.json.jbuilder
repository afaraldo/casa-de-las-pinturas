json.array!(@pagos) do |pago|
  json.extract! pago, :id
  json.url pago_url(pago, format: :json)
end
