class AddCajaIdToReciboDetalles < ActiveRecord::Migration
  def change
    add_reference :recibo_detalles, :caja, index: true
    add_foreign_key :recibo_detalles, :cajas

    ReciboDetalle.with_deleted.each do |d|
      d.update_column(:caja_id, Caja.get_caja_por_forma(d.forma).id)
    end

    CajaMovimiento.with_deleted.each do |m|
      m.update_column(:caja_id, Caja.get_caja_por_forma(:efectivo).id)
    end
  end
end
