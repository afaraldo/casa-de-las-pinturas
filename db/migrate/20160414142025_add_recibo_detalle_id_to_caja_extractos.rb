class AddReciboDetalleIdToCajaExtractos < ActiveRecord::Migration
  def change
    add_reference :caja_extractos, :recibo_detalle, index: true
    add_foreign_key :caja_extractos, :recibo_detalles
  end
end
