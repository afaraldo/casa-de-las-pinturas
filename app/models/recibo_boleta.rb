class ReciboBoleta < ActiveRecord::Base

  acts_as_paranoid

  self.table_name = 'recibos_boletas'

  after_save :actualizar_boletas
  after_destroy :actualizar_boletas

  belongs_to :recibo
  belongs_to :boleta

  accepts_nested_attributes_for :recibo, reject_if: :all_blank, allow_destroy: true

  validate  :monto_utilizado_boletas

  # Validar que el monto a pagar de la compra sea mayor a cero y menor al importe pendiente
  def monto_utilizado_boletas
    importe_pendiente = boleta.importe_pendiente
    importe_pendiente += monto_utilizado_was if persisted? # sumar el monto_utilizado anterior si se esta editando
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.monto_superior_a_pendiente')) if importe_pendiente < monto_utilizado
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.monto_utilizado_cero')) if monto_utilizado <= 0
    false if errors.size > 0
  end

  # actualizar las boletas a asociadas a los recibos
  def actualizar_boletas

    pendiente = boleta.importe_pendiente

    if deleted?
      pendiente += monto_utilizado # sumar el monto utilizado si se eliminar el recibo
    else
      pendiente -= (monto_utilizado.to_f - monto_utilizado_was.to_f) # restar la diferencia al crear o actualizar
    end

    boleta.update_columns(importe_pendiente: pendiente, estado: pendiente == 0 ? :pagado : :pendiente)

  end

end
