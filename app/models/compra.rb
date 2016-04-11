class Compra < Boleta
  belongs_to :proveedor, foreign_key: "persona_id"
  delegate :nombre, to: :proveedor, prefix: true

  has_many :pagos_detalles, class_name: 'ReciboBoleta', foreign_key: "recibo_id", dependent: :restrict_with_error, inverse_of: :boleta
  has_many :pagos, class_name: 'Pago', dependent: :restrict_with_error, through: :pagos_detalles, source: 'recibo'

  enumerize :estado, in: [:pendiente, :pagado], predicates: true

  before_save :set_importe_total, :set_importe_pendiente, :set_estado

  private

  def set_importe_pendiente
    monto_pagado = 0
    self.pagos_detalles.each do |p|
      monto_pagado += p.monto_utilizado
    end
    self.importe_pendiente = self.importe_total - monto_pagado
  end

  def set_estado
    if self.importe_pendiente == 0
      self.estado = :pagado
    else
      self.estado = :pendiente
    end
  end
end
