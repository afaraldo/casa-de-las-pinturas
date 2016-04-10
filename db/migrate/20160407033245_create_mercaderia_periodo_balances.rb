class CreateMercaderiaPeriodoBalances < ActiveRecord::Migration
  def change
    create_table :mercaderia_periodo_balances do |t|
      t.belongs_to :mercaderia, index: true
      t.integer :mes
      t.integer :anho
      t.decimal :balance, precision: 15, scale: 3

      t.timestamps null: false
    end
    add_foreign_key :mercaderia_periodo_balances, :mercaderias
  end
end
