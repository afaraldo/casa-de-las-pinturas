class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :nombre,     limit: 40
      t.string :telefono,   limit: 20
      t.string :direccion,  limit: 200
      t.string :ruc,        limit: 30
      t.string :type, null: false, limit: 15
      t.decimal :limite_credito

      t.timestamps null: false
    end
  end
end
