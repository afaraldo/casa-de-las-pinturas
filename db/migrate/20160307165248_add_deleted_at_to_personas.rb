class AddDeletedAtToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :deleted_at, :datetime
    add_index :personas, :deleted_at
  end
end
