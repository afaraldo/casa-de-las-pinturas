class AddCondicionToRecibo < ActiveRecord::Migration
  def change
    add_column :recibos, :condicion, :string, limit: 20, null: false
  end
end
