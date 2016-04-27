class AddDeletedAtToCajaMovimientoDetalles < ActiveRecord::Migration
  def change
    add_column :caja_movimiento_detalles, :deleted_at, :datetime
  end
end
