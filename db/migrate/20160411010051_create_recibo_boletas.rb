class CreateReciboBoletas < ActiveRecord::Migration
  def change
    create_table :recibo_boleta do |t|
      t.belongs_to :recibo, index: true
      t.belongs_to :boleta, index: true
      t.decimal :monto_utilizado, precision: 15, scale: 2

      t.timestamps null: false
    end

    add_foreign_key :recibo_boleta, :recibos
    add_foreign_key :recibo_boleta, :boletas
  end
end
