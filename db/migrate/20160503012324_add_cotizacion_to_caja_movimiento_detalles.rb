class AddCotizacionToCajaMovimientoDetalles < ActiveRecord::Migration
  def change
    add_column :caja_movimiento_detalles, :cotizacion, :decimal, precision: 15, scale: 2

    # actualizar importes de movimientos guardados
    CajaMovimiento.with_deleted.each do |m|
      m.importe_total = 0

      m.detalles.each do |d|
        d.cotizacion = d.moneda.cotizacion
        d.save
        m.importe_total += d.monto * d.cotizacion
      end

      m.save
    end
  end
end
