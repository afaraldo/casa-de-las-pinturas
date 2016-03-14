class CreateMercaderias < ActiveRecord::Migration
  def change
    create_table :mercaderias do |t|
      t.string :codigo,           limit: 20, index: true
      t.string :nombre,           limit: 50, index: true
      t.string :descripcion,      limit: 150
      t.string :unidad_de_medida, limit: 10, null: false
      t.decimal :precio_venta_contado, precision: 15, scale: 2, null: false, default: 0
      t.decimal :precio_venta_credito, precision: 15, scale: 2, null: false, default: 0
      t.decimal :costo,                precision: 15, scale: 2, null: false, default: 0
      t.references :categoria, index: true

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end

    add_foreign_key :mercaderias, :categorias
  end
end
