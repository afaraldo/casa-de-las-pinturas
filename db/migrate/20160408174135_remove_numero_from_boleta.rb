class RemoveNumeroFromBoleta < ActiveRecord::Migration
  def change
    remove_column :boletas, :numero, :integer
  end
end
