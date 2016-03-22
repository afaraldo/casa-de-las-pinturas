class CreateMovimientoMercaderias < ActiveRecord::Migration
  def change
    create_table :movimiento_mercaderias do |t|
      t.datetime :fecha
      t.string :motivo, limit: 255
      t.string :tipo, limit: 15
      t.datetime :deleted_at, null: true

      t.timestamps null: false
    end
  end
end
