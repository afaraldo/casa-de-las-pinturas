class NotasCreditosDebito < ActiveRecord::Base
  include MovimientosHelper

  acts_as_paranoid

  has_many :detalles, class_name: 'NotaCreditoDebitoDetalle', dependent: :destroy, inverse_of: :notas_creditos_debito

  has_many :boletas_detalles, class_name: 'MercaderiasDevolucionesBoleta', foreign_key: "notas_creditos_debito_id", dependent: :destroy, inverse_of: :notas_creditos_debito
  has_many :boletas, class_name: 'Boleta', dependent: :destroy, through: :boletas_detalles

  accepts_nested_attributes_for :detalles, reject_if: proc { |attrs| (attrs['monto'].to_f * attrs['cotizacion'].to_f) <= 0 }, allow_destroy: true
  accepts_nested_attributes_for :boletas_detalles, allow_destroy: true


  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

end
