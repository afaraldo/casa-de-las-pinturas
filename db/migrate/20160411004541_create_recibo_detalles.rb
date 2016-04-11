class CreateReciboDetalles < ActiveRecord::Migration
  def change
    create_table :recibo_detalles do |t|
      t.belongs_to :recibo, index: true
      t.string :forma, limit: 10
      t.decimal :monto, precision: 15, scale: 2
      t.decimal :cotizacion, precision: 15, scale: 2
      t.belongs_to :moneda, index: true

      t.timestamps null: false
    end

    add_foreign_key :recibo_detalles, :recibos
    add_foreign_key :recibo_detalles, :monedas
  end
end
