class AddNotasCreditosDebitoIdToCuentaCorrienteExtractos < ActiveRecord::Migration
  def change
    add_reference :cuentas_corrientes_extractos, :notas_creditos_debito, index: true
    add_foreign_key :cuentas_corrientes_extractos, :notas_creditos_debitos
  end
end
