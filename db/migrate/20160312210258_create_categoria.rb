class CreateCategoria < ActiveRecord::Migration
  def change
    create_table :categorias do |t|
      t.string :nombre, limit: 50, null: false
      t.integer :categoria_padre_id, null: true
      t.datetime :deleted_at, null: true

      t.timestamps null: false
    end
  end
end
