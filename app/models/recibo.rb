class Recibo < ActiveRecord::Base
  include MovimientosHelper

  acts_as_paranoid

  self.inheritance_column = 'tipo'

  before_validation :set_importes
  after_save :actualizar_cuenta_corriente, :actualizar_extracto_cajas
  after_destroy :actualizar_cuenta_corriente

  belongs_to :persona, foreign_key: "persona_id", inverse_of: :recibos

  has_many :detalles, class_name: 'ReciboDetalle', dependent: :destroy, inverse_of: :recibo

  has_many :boletas_detalles, class_name: 'ReciboBoleta', foreign_key: "recibo_id", dependent: :destroy, inverse_of: :recibo
  has_many :boletas, class_name: 'Boleta', dependent: :destroy, through: :boletas_detalles

  accepts_nested_attributes_for :detalles, reject_if: proc { |attrs| (attrs['monto'].to_f * attrs['cotizacion'].to_f) <= 0 }, allow_destroy: true
  accepts_nested_attributes_for :boletas_detalles, allow_destroy: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :persona_id, presence: true
  validate  :fecha_futura
  validate  :pagos_boletas_seleccionadas

  def total_pagado
    total_efectivo + total_tarjeta - total_credito_utilizado
  end

  def total_pagado_was
    total_efectivo_was.to_f + total_tarjeta_was.to_f - total_credito_utilizado_was.to_f
  end

  def numero
    id
  end

  def movimiento_motivo
    "#{tipo} Nro. #{numero}"
  end

  private

  def actualizar_cuenta_corriente
    if deleted?
      CuentaCorrienteExtracto.eliminar_movimiento(self.becomes(Recibo), fecha, total_pagado)
    else
      CuentaCorrienteExtracto.crear_o_actualizar_extracto(self.becomes(Recibo), fecha, total_pagado_was.to_f * -1, total_pagado.to_f * -1)
    end
  end

  def actualizar_extracto_cajas
    if !fecha_was.nil? && fecha_changed? && fecha_cambio_de_periodo?(fecha, fecha_was)
      detalles.each do |d|
        d.actualizar_extractos
      end
    end
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

  # Validar que el total de las formas de pago sea igual al total de las boletas seleccionadas
  def pagos_boletas_seleccionadas
    boletas_seleccionadas = 0

    boletas_detalles.each do |b|
      unless b.marked_for_destruction?
        boletas_seleccionadas += b.monto_utilizado
      end
    end

    if total_pagado != boletas_seleccionadas
      errors.add(:importe_total, I18n.t('activerecord.errors.messages.total_pagado_diferente_de_boletas'))
      false
    end
  end

  # para poder buscar por el id y numero comprobante
  ransacker :id do
    Arel.sql("to_char(\"#{table_name}\".\"id\", '99999')")
  end

end
