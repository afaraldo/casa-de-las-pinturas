class CreateStocks < ActiveRecord::Migration
  def change
    add_column :mercaderias, :stock,        :decimal, precision: 15, scale: 3, null: false, default: 0
    add_column :mercaderias, :stock_minimo, :decimal, precision: 15, scale: 2, null: false, default: 0
  end
end
