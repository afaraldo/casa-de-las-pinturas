class CreateBoletaDetalles < ActiveRecord::Migration
  def change
    create_table :boleta_detalles do |t|
      t.references :boleta, index: true
      t.references :mercaderia, index: true
      t.decimal :cantidad, precision: 15, scale: 3, null: false
      t.decimal :precio_unitario, precision: 15, scale: 2, null: false

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :boleta_detalles, :boletas
    add_foreign_key :boleta_detalles, :mercaderias
  end
end
