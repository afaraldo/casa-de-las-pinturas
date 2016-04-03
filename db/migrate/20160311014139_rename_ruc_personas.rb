class RenameRucPersonas < ActiveRecord::Migration
  def change
    rename_column :personas, :ruc, :numero_documento
    rename_column :personas, :type, :tipo
  end
end
