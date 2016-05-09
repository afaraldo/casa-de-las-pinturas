class RenameStockMercaderias < ActiveRecord::Migration
  def change
  	rename_column :mercaderias, :stock, :stock_inicial
  end
end
