class Boleta < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  self.inheritance_column = 'tipo'

  has_many :detalles, class_name: 'BoletaDetalle', dependent: :destroy, inverse_of: :boleta
  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

  enumerize :condicion, in: [:contado, :credito], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :detalles, length: { minimum: 1 }
  validates :numero_comprobante, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validate  :fecha_futura, :fecha_vencimiento_mayor_a_fecha
  validate  :condicion_no_cambiada, on: :update

  def numero
    id
  end

  def importe_pagado
    self.importe_total - self.importe_pendiente
  end

  def set_importe_total
    self.importe_total = 0
    self.detalles.each do |detalle|
        self.importe_total += detalle.precio_unitario * detalle.cantidad
    end
  end

  private

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  def fecha_vencimiento_mayor_a_fecha
    if fecha > fecha_vencimiento
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_vencimiento'))
    end
  end

  def condicion_no_cambiada
    if condicion_changed? && self.persisted?
      errors.add(:condicion, I18n.t('activerecord.errors.messages.no_editable'))
    end
  end

end
