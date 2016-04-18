class AddComprobanteToRecibos < ActiveRecord::Migration
  def change
    add_column :recibos, :numero_comprobante, :string, limit: 50
  end
end
