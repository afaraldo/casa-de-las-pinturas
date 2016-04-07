class CreatePagos < ActiveRecord::Migration
  def change
    create_table :pagos do |t|
      t.integer :numero, null: false
      t.datetime :fecha, null: false
      t.decimal :total_efectivo, precision: 15, scale: 2, null: false
      t.decimal :total_tarjeta, precision: 15, scale: 2, null: false
      t.decimal :total_credito_utilizado, precision: 15, scale: 2, null: false
      t.string :tipo, limit: 20, null: false
      t.datetime :deleted_at, null: true

      t.timestamps null: false
    end
  end
end
