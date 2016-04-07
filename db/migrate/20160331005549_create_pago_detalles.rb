class CreatePagoDetalles < ActiveRecord::Migration
  def change
    create_table :pago_detalles do |t|
      t.references :pago, index: true
      t.string :forma, limit: 20, null: false
      t.decimal :monto, precision: 15, scale: 2, null: false
      t.references :moneda, index: true
      t.decimal :cotizacion, precision: 15, scale: 2, null: false

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :pago_detalles, :pagos
    add_foreign_key :pago_detalles, :monedas
  end
end
