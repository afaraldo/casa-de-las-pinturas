
################################
# FABRICANDO DATOS DE EJEMPLO  #
################################

Fabricator(:categoria) do
  nombre { Faker::Commerce.department(1) }
end

Fabricator(:proveedor) do
  nombre { Faker::Company.name }
  telefono { Faker::PhoneNumber.cell_phone }
  direccion { Faker::Address.street_address }
  numero_documento { Faker::Company.ein }
  limite_credito { Faker::Number.between(400000, 2000000) }
end

Fabricator(:mercaderia) do
  nombre { Faker::Commerce.product_name }
  categoria_id { Categoria.offset(rand(Categoria.count)).first.id }
  codigo { Faker::Code.ean(8) }
  precio_venta_contado { Faker::Number.between(2000, 50000) }
  precio_venta_credito { Faker::Number.between(2000, 50000) }
  stock { Faker::Number.positive(20, 200) }
  stock_minimo { Faker::Number.positive(20, 30) }
  unidad_de_medida { :unidad }
end

15.times {
  begin
    Fabricate(:categoria)
  rescue
    next
  end
}

30.times {
  begin
    Fabricate(:mercaderia)
  rescue
    next
  end
}

30.times {
  begin
    Fabricate(:proveedor)
  rescue
    next
  end
}

# Crear configuraciones si no existe
if Configuracion.first.nil?
  Configuracion.create( empresa_nombre:'Casa de las pinturas',
                        empresa_direccion:'Avda. Caballero c/ Carlos A. Lopez',
                        empresa_telefono:'071-203917',
                        empresa_email:'lcdpt@info.com')
end