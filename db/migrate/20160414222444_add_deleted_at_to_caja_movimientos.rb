class AddDeletedAtToCajaMovimientos < ActiveRecord::Migration
  def change
    add_column :caja_movimientos, :deleted_at, :datetime
  end
end
