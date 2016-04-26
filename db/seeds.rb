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

Fabricator(:cliente) do
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

unless Categoria.count > 15
  15.times {
    begin
      Fabricate(:categoria)
    rescue
      next
    end
  }
end

unless Mercaderia.count > 30
  30.times {
    begin
      Fabricate(:mercaderia)
    rescue
      next
    end
  }
end


unless Proveedor.count > 30
  30.times {
    begin
      Fabricate(:proveedor)
    rescue
      next
    end
  }
end

unless Cliente.count > 30
  30.times {
    begin
      Fabricate(:cliente)
    rescue
      next
    end
  }
end

# Crear configuraciones si no existe
if Configuracion.first.nil?
  Configuracion.create( empresa_nombre:'Casa de las pinturas',
                        empresa_direccion:'Avda. Caballero c/ Carlos A. Lopez',
                        empresa_telefono:'071-203917',
                        empresa_email:'lcdpt@info.com')
end

# Crear un empleado
@superuser = Persona.create nombre: 'Super Administrador', direccion:'', telefono: '', numero_documento: '12345678',  tipo: "Empleado", limite_credito: 0, user_attributes: { username: 'admin', password: 'Admin+123', rol: 'superusuario' } if User.find_by_username('admin').nil?
@administrador = Persona.create nombre: 'Laura Perez', direccion:'Nuevo circuito comercial', telefono: '0985123456', numero_documento: '1234567-8',  tipo: "Empleado", limite_credito: 0, user_attributes: { username: 'laura', password: 'Admin+123', rol: 'administrador' } if User.find_by_username('laura').nil?

# Crear monedas
Moneda.create nombre: 'Guarani',        abreviatura: 'Gs',  cotizacion: 1,    defecto: true   if Moneda.find_by_nombre('Guarani').nil?
Moneda.create nombre: 'Peso Argentino', abreviatura: 'Ps',  cotizacion: 300,  defecto: false  if Moneda.find_by_nombre('Peso Argentino').nil?
Moneda.create nombre: 'Dolar',          abreviatura: '$',   cotizacion: 5000, defecto: false  if Moneda.find_by_nombre('Dolar').nil?
Moneda.create nombre: 'Real Brasileño', abreviatura: 'R',   cotizacion: 3000, defecto: false  if Moneda.find_by_nombre('Real Brasileño').nil?

Caja.create(nombre: :efectivo) if Caja.get_caja_por_forma(:efectivo).nil?
Caja.create(nombre: :tarjeta) if Caja.get_caja_por_forma(:tarjeta).nil?