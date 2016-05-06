class ChangeColumnMovimientoTipoToCajaExtractos < ActiveRecord::Migration
  def change
    change_column :caja_extractos, :movimiento_tipo, :string, limit: 50
  end
end
