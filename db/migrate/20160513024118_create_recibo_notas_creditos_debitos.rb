class CreateReciboNotasCreditosDebitos < ActiveRecord::Migration
  def change
    create_table :recibo_notas_creditos_debitos do |t|
      t.belongs_to :recibo, index: true
      t.belongs_to :notas_creditos_debito, index: true
      t.decimal :monto_utilizado, precision: 15, scale: 2

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :recibo_notas_creditos_debitos, :recibos
    add_foreign_key :recibo_notas_creditos_debitos, :notas_creditos_debitos
  end
end
