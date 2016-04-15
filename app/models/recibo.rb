class Recibo < ActiveRecord::Base

  acts_as_paranoid

  self.inheritance_column = 'tipo'

  before_save :set_importes
  after_save :actualizar_boletas, :actualizar_cuenta_corriente

  has_many :detalles, class_name: 'ReciboDetalle', dependent: :destroy, inverse_of: :recibo

  has_many :boletas_detalles, class_name: 'ReciboBoleta', foreign_key: "recibo_id", dependent: :destroy, inverse_of: :recibo
  has_many :boletas, class_name: 'Boleta', dependent: :destroy, through: :boletas_detalles

  accepts_nested_attributes_for :detalles, reject_if: proc { |attrs| (attrs['monto'].to_f * attrs['cotizacion'].to_f) <= 0 }, allow_destroy: true
  accepts_nested_attributes_for :boletas_detalles

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validate  :fecha_futura

  def total_pagado
    total_efectivo + total_tarjeta - total_credito_utilizado
  end

  def numero
    id
  end

  private

  # Luego de guardar los recibos se actualizan los importes y estado de las boletas
  def actualizar_boletas
    boletas_detalles.each do |b|

      boleta = b.boleta
      pendiente = boleta.importe_pendiente - b.monto_utilizado

      #binding.pry

      boleta.update_columns(importe_pendiente: pendiente, estado: pendiente == 0 ? :pagado : :pendiente)

    end
  end

  def actualizar_cuenta_corriente
    # CuentaCorrienteExtracto.crear_o_actualizar_extracto(self, fecha, total_pagado, 0)
  end

  def set_importes
    self.total_efectivo = 0
    self.total_tarjeta = 0
    self.total_credito_utilizado = 0

    detalles.each do |d|
      self.total_efectivo += (d.monto * d.cotizacion) if d.forma.efectivo?
      self.total_tarjeta += (d.monto * d.cotizacion) if d.forma.tarjeta?
    end
  end

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

end
