class RemovePagos < ActiveRecord::Migration
  def change
    drop_table :pago_detalles
    drop_table :pagos
  end
end
