class AddCondicionToRecibo < ActiveRecord::Migration
  def change
    add_column :recibos, :condicion, :string, limit: 20

    Recibo.with_deleted.each do |r|
      r.update_column(:condicion, :credito)
    end

    change_column_null :recibos, :condicion, false
  end
end
