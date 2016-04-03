class AddAvatarToConfiguraciones < ActiveRecord::Migration
  def change
    add_column :configuraciones, :avatar, :string
  end
end
