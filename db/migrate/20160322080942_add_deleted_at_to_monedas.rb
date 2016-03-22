class AddDeletedAtToMonedas < ActiveRecord::Migration
  def change
    add_column :monedas, :deleted_at, :datetime
    add_index :monedas, :deleted_at
  end
end
