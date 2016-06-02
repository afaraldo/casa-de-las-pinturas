class NotaCreditoDebitoDetalle < ActiveRecord::Base

  acts_as_paranoid

  after_save :update_stock
  after_destroy :update_stock

  belongs_to :notas_creditos_debito
  belongs_to :mercaderia

  delegate :nombre, to: :mercaderia, prefix: true
  delegate :codigo, to: :mercaderia, prefix: true

  validates :cantidad, numericality: { greater_than: 0, less_than_or_equal_to: DECIMAL_LIMITE[:superior] }
  validate :validar_cantidad_boleta

  def validar_cantidad_boleta
    boleta = Boleta.find(notas_creditos_debito.boletas_detalles.first.boleta_id)
    detalle = boleta.detalles.find_by(mercaderia_id: mercaderia_id)

    total_devuelto = 0

    boleta.notas_creditos_debitos.each do |d|
      detalle_devolucion = d.detalles.find_by(mercaderia_id: mercaderia_id)

      if detalle_devolucion && self.id != detalle_devolucion.id
        total_devuelto += detalle_devolucion.cantidad
      end

    end

    if cantidad + total_devuelto > detalle.cantidad
      errors.add(:cantidad, "La cantidad no puede ser mayor al de la boleta: #{detalle.cantidad - total_devuelto}")
    end
  end

  # Comprobar que la cantidad no provoque stock negativo o que sea mayor al limite definido
  def check_stock_rango
    c = nueva_cantidad
    unless c < DECIMAL_LIMITE[:superior]
      errors.add(:cantidad, I18n.t('movimiento_mercaderia.detalle_cantidad_stock_superior', limite: DECIMAL_LIMITE[:superior]))
      false
    end
  end

  def nueva_cantidad(borrado = false)
    nueva_cantidad =  borrado ? 0 : cantidad
    nueva_cantidad_diff = nueva_cantidad - cantidad_was.to_f

    cantidad_ = mercaderia.stock_actual
    cantidad_ -= nueva_cantidad_diff if notas_creditos_debito.tipo == 'DevolucionCompra'
    cantidad_ += nueva_cantidad_diff if notas_creditos_debito.tipo == 'DevolucionVenta'
    cantidad_
  end

  # Actualizar el stock si es que cambio la cantidad o se elimino el detalle
  def update_stock
    operador = self.notas_creditos_debito.tipo == 'DevolucionCompra' ? -1 : 1
   if deleted?
      MercaderiaExtracto.eliminar_movimiento(self, self.notas_creditos_debito.fecha, cantidad * operador*-1)
    else
      MercaderiaExtracto.crear_o_actualizar_extracto(self, self.notas_creditos_debito.fecha, cantidad_was.to_f * operador, cantidad * operador)
    end
  end

  def as_json(options={})
    super(:methods => [:mercaderia_codigo, :mercaderia_nombre])
  end
end
