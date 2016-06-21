class AddIndexBoletaDetalle < ActiveRecord::Migration
  def change
    add_index :mercaderia_extractos, :boleta_detalle_id
  end
end
