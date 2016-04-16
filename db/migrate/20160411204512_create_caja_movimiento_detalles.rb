class CreateCajaMovimientoDetalles < ActiveRecord::Migration
  def change
    create_table :caja_movimiento_detalles do |t|
      t.belongs_to :caja_movimiento, index: true
      t.belongs_to :moneda, index: true
      t.decimal :monto, precision: 15, scale: 2, null: false, default: 0
      t.string :forma, limit: 20, null: false

      t.timestamps null: false
    end
    add_foreign_key :caja_movimiento_detalles, :caja_movimientos
    add_foreign_key :caja_movimiento_detalles, :monedas
  end
end
