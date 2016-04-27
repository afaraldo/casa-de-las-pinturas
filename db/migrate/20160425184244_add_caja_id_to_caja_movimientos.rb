class AddCajaIdToCajaMovimientos < ActiveRecord::Migration
  def change
  	add_reference :caja_movimientos, :caja, index: true
  	add_foreign_key :caja_movimientos, :cajas
  end
end
