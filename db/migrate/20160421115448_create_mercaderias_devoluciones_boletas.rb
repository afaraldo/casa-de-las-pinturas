class CreateMercaderiasDevolucionesBoletas < ActiveRecord::Migration
  def change
    create_table :mercaderias_devoluciones_boletas do |t|
      t.references :boleta, index: true
      t.datetime :fecha
      t.references :persona
      t.string :motivo

      t.timestamps null: false
    end
    add_foreign_key :mercaderias_devoluciones_boletas, :boletas
  end
end
