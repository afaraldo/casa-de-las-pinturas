class AddEsTransferenciaToCajaMovimiento < ActiveRecord::Migration
  def change
    add_column :caja_movimientos, :es_transferencia, :boolean
  end
end
