class AddDeletedAtToBoletasNotasCreditosDebitos < ActiveRecord::Migration
  def change
    add_column :boletas_notas_creditos_debitos, :deleted_at, :datetime
  end
end
