class ChangeColumnLimitToPersonas < ActiveRecord::Migration
  def change
    change_column :personas, :nombre, :string, limit: 150
    change_column :personas, :telefono, :string, limit: 50
    change_column :personas, :numero_documento, :string, limit: 20
  end
end
