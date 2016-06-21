class CreateReciboNotaCreditoDebitos < ActiveRecord::Migration
  def change
    create_table :recibo_nota_credito_debitos do |t|
      t.references :notas_creditos_debito, index: true
      t.references :recibo, index: true
      t.decimal :monto_utilizado, precision: 15, scale: 2, null: false

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :recibo_nota_credito_debitos, :notas_creditos_debitos
    add_foreign_key :recibo_nota_credito_debitos, :recibos
  end
end
