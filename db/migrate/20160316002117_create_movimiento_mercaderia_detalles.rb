class CreateMovimientoMercaderiaDetalles < ActiveRecord::Migration
  def change
    create_table :movimiento_mercaderia_detalles do |t|
      t.belongs_to :movimiento_mercaderia, index: { name: 'index_mov_mercaderia_det_on_movimiento_mercaderia_id' }
      t.belongs_to :mercaderia, index: true
      t.decimal :cantidad, precision: 15, scale: 3
      t.datetime :deleted_at, null: true

      t.timestamps null: false
    end
    add_foreign_key :movimiento_mercaderia_detalles, :movimiento_mercaderias
    add_foreign_key :movimiento_mercaderia_detalles, :mercaderias
  end
end
