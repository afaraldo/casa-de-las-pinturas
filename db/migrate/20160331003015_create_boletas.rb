class CreateBoletas < ActiveRecord::Migration
  def change
    create_table :boletas do |t|
      t.references :persona, index: true
      t.integer :numero, null: false
      t.integer :numero_factura, null: true
      t.datetime :fecha, null: false
      t.datetime :fecha_vencimiento, null: true
      t.string :estado, limit: 20, null: false
      t.string :tipo, limit: 20, null: false
      t.string :condicion, limit: 20, null: false
      t.decimal :importe_total, precision: 15, scale: 2, null: false
      t.decimal :importe_pendiente, precision: 15, scale: 2, null: false
      t.decimal :importe_descontado, precision: 15, scale: 2, null: false, default: 0

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :boletas, :personas
  end
end
