class CreateCuentaCorrientePeriodoBalances < ActiveRecord::Migration
  def change
    create_table :cuenta_corriente_periodo_balances do |t|
      t.references :persona, index: true
      t.integer :mes, null: false
      t.integer :anho, null: false
      t.decimal :balance, null: false, precision: 15, scale: 2

      t.timestamps null: false
    end
    add_foreign_key :cuenta_corriente_periodo_balances, :personas
  end
end
