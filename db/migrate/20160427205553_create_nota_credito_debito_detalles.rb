class CreateNotaCreditoDebitoDetalles < ActiveRecord::Migration
  def change
    create_table :nota_credito_debito_detalles do |t|
      t.references :notas_creditos_debito, index: true
      t.references :mercaderia, index: true
      t.decimal :cantidad, precision: 15, scale: 3, null: false
      t.decimal :precio_unitario, precision: 15, scale: 2, null: false

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :nota_credito_debito_detalles, :notas_creditos_debitos
    add_foreign_key :nota_credito_debito_detalles, :mercaderias
  end
end
