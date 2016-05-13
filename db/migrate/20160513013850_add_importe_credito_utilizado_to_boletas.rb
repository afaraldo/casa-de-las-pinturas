class AddImporteCreditoUtilizadoToBoletas < ActiveRecord::Migration
  def change
    add_column :boletas, :importe_credito_utilizado, :decimal, precision: 15, scale: 2
  end
end
