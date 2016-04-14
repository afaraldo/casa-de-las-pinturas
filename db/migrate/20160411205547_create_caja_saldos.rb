class CreateCajaSaldos < ActiveRecord::Migration
  def change
    create_table :caja_saldos do |t|
      t.belongs_to :caja, index: true
      t.belongs_to :moneda, index: true
      t.decimal :saldo_efectivo, precision: 15, scale: 2, null: false, default: 0

      t.timestamps null: false
    end
    add_foreign_key :caja_saldos, :cajas
    add_foreign_key :caja_saldos, :monedas
  end
end
