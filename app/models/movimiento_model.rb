class MovimientoModel < ActiveRecord::Base
  self.abstract_class = true

  # Atributos por los que se va a buscar los movimientos
  # Ej. para MercaderiaExtracto debe ser: [:mercaderia_id]
  #     para CajaExtracto debe ser: [:caja_id, :moneda_id]
  class_attribute :movimiento_key

  def self.crear_o_actualizar_extracto(objeto, fecha, cantidad)
    # Crear o inicializar el movimiento
    movimiento = self.find_or_initialize_by(movimiento_tipo: objeto.class,
                                            objeto.class.to_s.underscore.concat('_id') => objeto.id)
    # setear los keys
    self.movimiento_key.each do |k|
      movimiento[k] = objeto[k]
    end

    movimiento.fecha = fecha
    movimiento.save

    # Actualizar balances
  

  end

end