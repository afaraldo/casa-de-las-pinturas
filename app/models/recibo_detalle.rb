class ReciboDetalle < ActiveRecord::Base
  extend Enumerize

  acts_as_paranoid

  attr_accessor :caja_id

  after_save :actualizar_extractos
  after_destroy :actualizar_extractos

  belongs_to :recibo
  belongs_to :moneda

  enumerize :forma, in: [:efectivo, :tarjeta], predicates: true

  delegate :nombre, to: :moneda, prefix: true

  def actualizar_extractos
    self.caja_id = Caja.get_caja_por_forma(forma).id
    operador = self.recibo.instance_of?(Pago) ? -1 : 1

    if deleted?
      CajaExtracto.eliminar_movimiento(self, self.recibo.fecha, monto * operador * -1)
    else
      CajaExtracto.crear_o_actualizar_extracto(self, self.recibo.fecha, monto_was.to_f * operador, monto.to_f * operador)
    end
  end

end
