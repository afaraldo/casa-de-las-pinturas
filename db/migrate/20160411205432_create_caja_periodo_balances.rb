class CreateCajaPeriodoBalances < ActiveRecord::Migration
  def change
    create_table :caja_periodo_balances do |t|
      t.belongs_to :caja, index: true
      t.belongs_to :moneda, index: true
      t.integer :mes
      t.integer :anho
      t.decimal :saldo, precision: 15, scale: 3
      t.string :tipo, limit: 20, null: false

      t.timestamps null: false
    end
    add_foreign_key :caja_periodo_balances, :cajas
    add_foreign_key :caja_periodo_balances, :monedas
  end
end
