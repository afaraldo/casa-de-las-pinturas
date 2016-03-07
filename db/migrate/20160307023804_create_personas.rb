class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :nombre
      t.string :telefono
      t.string :direccion
      t.string :ruc
      t.string :type, null: false
      t.decimal :limite_credito

      t.timestamps null: false
    end
  end
end
