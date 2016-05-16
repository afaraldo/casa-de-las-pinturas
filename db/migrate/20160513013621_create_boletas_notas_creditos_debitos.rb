class CreateBoletasNotasCreditosDebitos < ActiveRecord::Migration
  def change
    create_table :boletas_notas_creditos_debitos do |t|
      t.references :boleta, index: true
      t.references :notas_creditos_debito, index: { name: 'boletas_devoluciones_devolucion_id'}
      t.decimal :monto_utilizado, precision: 15, scale: 2
    end
    add_foreign_key :boletas_notas_creditos_debitos, :boletas
    add_foreign_key :boletas_notas_creditos_debitos, :notas_creditos_debitos
  end
end
