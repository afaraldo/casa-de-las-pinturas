class CreateRecibosNotasCreditosDebitos < ActiveRecord::Migration
  def change
    create_table :recibos_notas_creditos_debitos do |t|
      t.references :recibo, index: true
      t.references :notas_creditos_debito, index: true
      t.references :notas_creditos_debito, index: { name: 'recibos_devoluciones_devolucion_id'}
      t.decimal :monto_utilizado, precision: 15, scale: 2
      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :recibos_notas_creditos_debitos, :recibos
    add_foreign_key :recibos_notas_creditos_debitos, :notas_creditos_debitos
  end
end
