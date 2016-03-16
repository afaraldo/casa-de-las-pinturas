class CreateConfiguraciones < ActiveRecord::Migration
  def change
    create_table :configuraciones do |t|
      t.string :empresa_nombre
      t.string :empresa_direccion
      t.string :empresa_telefono
      t.string :empresa_email

      t.timestamps null: false
    end
  end
end
