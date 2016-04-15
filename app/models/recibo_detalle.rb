class ReciboDetalle < ActiveRecord::Base
  extend Enumerize

  attr_accessor :caja_id

  after_save :actualizar_extractos

  belongs_to :recibo
  belongs_to :moneda

  enumerize :forma, in: [:efectivo, :tarjeta], predicates: true

  delegate :nombre, to: :moneda, prefix: true

  def actualizar_extractos
    self.caja_id = Caja.get_caja_por_forma(forma).id
    CajaExtracto.crear_o_actualizar_extracto(self, self.recibo.fecha, monto, 0)
  end

end
