# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@empleado = Persona.create nombre: 'Laura Perez', direccion:'Nuevo circuito comercial', telefono: '12345678', ruc: '1234567-8',  type: "Empleado", limite_credito: 0, user_attributes: { username: 'admin', email: 'admin@casadelaspinturas.com', password: '12345678' }
