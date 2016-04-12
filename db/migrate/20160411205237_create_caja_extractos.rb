class CreateCajaExtractos < ActiveRecord::Migration
  def change
    create_table :caja_extractos do |t|
      t.belongs_to :caja, index: true
      t.belongs_to :moneda, index: true
      t.belongs_to :caja_movimiento_detalle, index: true
      t.datetime :fecha, null:false
      t.string :movimiento_tipo, limit: 20, null: false

      t.timestamps null: false
    end
    add_foreign_key :caja_extractos, :cajas
    add_foreign_key :caja_extractos, :monedas
    add_foreign_key :caja_extractos, :caja_movimiento_detalles
  end
end
