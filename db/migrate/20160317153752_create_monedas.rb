class CreateMonedas < ActiveRecord::Migration
  def change
    create_table :monedas do |t|
      t.string :nombre
      t.string :abreviatura
      t.decimal :cotizacion, precision: 15, scale: 2, null: false, default: 0
      t.boolean :defecto, default: false

      t.timestamps null: false
    end
  end
end
