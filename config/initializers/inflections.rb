# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  # inflect.plural /^(ox)$/i, '\1en'
  # inflect.singular /^(ox)en/i, '\1'
  # inflect.irregular 'person', 'people'
  # inflect.uncountable %w( fish sheep )
  inflect.irregular 'proveedor', 'proveedores'
  inflect.irregular 'categoria', 'categorias'
  inflect.irregular 'mercaderia', 'mercaderias'
  inflect.irregular 'movimiento_mercaderia', 'movimiento_mercaderias'
  inflect.irregular 'movimiento_mercaderia_detalle', 'movimiento_mercaderia_detalles'
  inflect.irregular 'configuracion', 'configuraciones'
  inflect.irregular 'boleta', 'boletas'
  inflect.irregular 'boleta_detalle', 'boleta_detalles'
  inflect.irregular 'pago', 'pagos'
  inflect.irregular 'pago_detalle', 'pago_detalles'
  inflect.irregular 'mercaderia_extracto', 'mercaderia_extractos'
  inflect.irregular 'mercaderia_periodo_balance', 'mercaderia_periodo_balances'
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
