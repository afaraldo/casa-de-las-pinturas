class AddColumnBoletaDetalleIdToMercarderiasExtractos < ActiveRecord::Migration
  def change
    add_column :mercaderia_extractos, :boleta_detalle_id, :integer, index: true
    add_foreign_key :mercaderia_extractos, :boleta_detalles
  end
end
