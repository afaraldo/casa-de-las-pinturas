class AddDeletedAtToRecibosDetalles < ActiveRecord::Migration
  def change
    add_column :recibos_boletas, :deleted_at, :datetime, null: true
  end
end
