class ReciboBoleta < ActiveRecord::Base
  self.table_name = 'recibos_boletas'

  belongs_to :recibo
  belongs_to :boleta

  validate  :monto_utilizado_boletas

  def monto_utilizado_boletas
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.monto_superior_a_pendiente')) if boleta.importe_pendiente < monto_utilizado
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.monto_utilizado_cero')) if monto_utilizado <= 0
    false if errors.size > 0
  end

end
