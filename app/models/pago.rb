class Pago < Recibo

  belongs_to :proveedor, foreign_key: 'persona_id'

  delegate :nombre, to: :proveedor, prefix: true

  has_many :boletas_detalles, class_name: 'ReciboBoleta', foreign_key: "boleta_id", dependent: :destroy, inverse_of: :recibo
  has_many :boletas, class_name: 'Boleta', dependent: :destroy, through: :boletas_detalles, source: 'boleta'

  validates :proveedor, presence: true

  def build_detalles
    Moneda.all.each do |m|
      detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
    end
  end
  
end
