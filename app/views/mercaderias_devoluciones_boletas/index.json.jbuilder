json.array!(@mercaderias_devoluciones_boletas) do |mercaderias_devoluciones_boleta|
  json.extract! mercaderias_devoluciones_boleta, :id, :boleta_id
  json.url mercaderias_devoluciones_boleta_url(mercaderias_devoluciones_boleta, format: :json)
end
