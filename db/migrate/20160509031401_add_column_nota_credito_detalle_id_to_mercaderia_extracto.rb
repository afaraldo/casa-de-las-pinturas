class AddColumnNotaCreditoDetalleIdToMercaderiaExtracto < ActiveRecord::Migration
  def change
    add_reference :mercaderia_extractos, :nota_credito_debito_detalle, index: true
    add_foreign_key :mercaderia_extractos, :nota_credito_debito_detalles
  end
end
