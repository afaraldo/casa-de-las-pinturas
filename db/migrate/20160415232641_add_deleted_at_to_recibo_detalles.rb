class AddDeletedAtToReciboDetalles < ActiveRecord::Migration
  def change
    add_column :recibo_detalles, :deleted_at, :datetime, null: true
  end
end
