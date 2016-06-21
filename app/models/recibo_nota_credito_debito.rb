class ReciboNotaCreditoDebito < ActiveRecord::Base

  acts_as_paranoid

  self.table_name = 'recibos_notas_creditos_debitos'

  after_save :actualizar_devoluciones
  after_destroy :actualizar_devoluciones

  belongs_to :recibo
  belongs_to :notas_creditos_debito

  validate  :monto_utilizado_devoluciones

  # Validar que el monto a utilizar de la devolcion sea mayor a cero y menor al importe disponible
  def monto_utilizado_devoluciones
    credito_restante = notas_creditos_debito.credito_restante
    credito_restante += monto_utilizado_was if persisted? # sumar el monto_utilizado anterior si se esta editando
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.credito_superior_a_disponible')) if credito_restante < monto_utilizado
    errors.add(:monto_utilizado, I18n.t('activerecord.errors.messages.monto_utilizado_cero')) if monto_utilizado <= 0
    false if errors.size > 0
  end

  # actualizar las devoluciones
  def actualizar_devoluciones

    credito_restante = notas_creditos_debito.credito_restante

    if deleted?
      credito_restante += monto_utilizado # sumar el monto utilizado si se eliminar la relacion
    else
      credito_restante -= (monto_utilizado.to_f - monto_utilizado_was.to_f) # restar la diferencia al crear o actualizar
    end

    notas_creditos_debito.update_columns(credito_restante: credito_restante)

  end

end
