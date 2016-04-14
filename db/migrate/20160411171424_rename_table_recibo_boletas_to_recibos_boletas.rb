class RenameTableReciboBoletasToRecibosBoletas < ActiveRecord::Migration
  def change
    rename_table :recibo_boleta, :recibos_boletas
  end
end
