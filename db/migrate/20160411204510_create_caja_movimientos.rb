class CreateCajaMovimientos < ActiveRecord::Migration
  def change
    create_table :caja_movimientos do |t|
      t.belongs_to :categoria_gasto, index: true
      t.datetime :fecha, null: false
      t.string :motivo, limit: 255, null: false
      t.string :tipo, limit: 20, null: false
      t.decimal :importe_total, precision: 15, scale: 2, null: false, default: 0

      t.timestamps null: false
    end
    add_foreign_key :caja_movimientos, :categoria_gastos
  end
end
