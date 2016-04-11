class CreateCategoriaGastos < ActiveRecord::Migration
  def change
    create_table :categoria_gastos do |t|
      t.string :nombre, limit: 50, null: false
      t.datetime :deleted_at, null: true
      
      t.timestamps null: false
    end
  end
end
