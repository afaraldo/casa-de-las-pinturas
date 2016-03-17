json.array!(@monedas) do |moneda|
  json.extract! moneda, :id, :nombre, :abreviatura, :cotizacion, :defecto
  json.url moneda_url(moneda, format: :json)
end
