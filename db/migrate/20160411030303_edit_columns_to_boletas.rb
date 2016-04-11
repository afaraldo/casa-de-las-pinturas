class EditColumnsToBoletas < ActiveRecord::Migration
  def change
    change_column :boletas, :numero_factura, :string
    rename_column :boletas, :numero_factura, :numero_comprobante
  end
end
