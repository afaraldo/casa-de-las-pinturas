class CreateMonedas < ActiveRecord::Migration
  def change
    create_table :monedas do |t|
      t.string :nombre
      t.string :abreviatura
      t.integer :cotizacion
      t.boolean :defecto

      t.timestamps null: false
    end
  end
end
