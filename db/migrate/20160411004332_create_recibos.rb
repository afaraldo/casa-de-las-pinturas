class CreateRecibos < ActiveRecord::Migration
  def change
    create_table :recibos do |t|
      t.datetime :fecha
      t.decimal :total_efectivo, precision: 15, scale: 2
      t.decimal :total_tarjeta, precision: 15, scale: 2
      t.decimal :total_credito_utilizado, precision: 15, scale: 2
      t.string :tipo, limit: 10

      t.datetime :deleted_at, null: true

      t.timestamps null: false
    end
  end
end
