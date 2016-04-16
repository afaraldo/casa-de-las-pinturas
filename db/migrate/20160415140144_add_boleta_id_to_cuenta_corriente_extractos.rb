class AddBoletaIdToCuentaCorrienteExtractos < ActiveRecord::Migration
  def change
    add_reference :cuentas_corrientes_extractos, :recibo, index: true
    add_foreign_key :cuentas_corrientes_extractos, :recibos
  end
end
