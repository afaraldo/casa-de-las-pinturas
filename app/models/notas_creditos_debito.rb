class NotasCreditosDebito < ActiveRecord::Base
  acts_as_paranoid

  self.inheritance_column = 'tipo'

  before_validation :set_importe_total
  after_save :actualizar_extracto_de_cuenta_corriente
  after_destroy :actualizar_extracto_de_cuenta_corriente
  after_save :actualizar_boleta

  has_many :detalles, class_name: 'NotaCreditoDebitoDetalle', dependent: :destroy, inverse_of: :notas_creditos_debito

  # Boletas correspondientes a la devolucion
  has_many :boletas_detalles, class_name: 'DevolucionesBoleta', foreign_key: "notas_creditos_debito_id", dependent: :destroy, inverse_of: :notas_creditos_debito
  has_many :boletas, class_name: 'Boleta', dependent: :destroy, through: :boletas_detalles

  # Boletas donde se uso el credito de la devolucion
  has_many :creditos_detalles, class_name: 'BoletaNotaCreditoDebito', foreign_key: "notas_creditos_debito_id", inverse_of: :notas_creditos_debito, dependent: :destroy
  has_many :creditos, class_name: 'Boleta', dependent: :destroy, through: :creditos_detalles, source: :boleta

  accepts_nested_attributes_for :boletas_detalles, allow_destroy: true
  accepts_nested_attributes_for :detalles, allow_destroy: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  # Validations
  validates :fecha,  presence: true
  validates :motivo, length: { minimum: 2, maximum: 50 }, allow_blank: false, presence: true
  validates :persona, presence: true
  validates :detalles, length: { minimum: 1 }
  validate  :fecha_futura
  validate  :persona_cambiada?, on: :update

  def movimiento_motivo
    "Devolucion Nro. #{id}"
  end

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  def es_editable?
    self.creditos.size == 0
  end

  def es_eliminable?
    es_editable?
  end

  def no_editable_mensaje
    "La devolución no se puede editar porque ya se ha utilizado."
  end

  def no_eliminable_mensaje
    "La devolución no se puede eliminar porque ya se ha utilizado."
  end

  def check_detalles_negativos(borrado = false)
    m = []
    detalles.each do |d|
      if d.nueva_cantidad(borrado) < 0
        m << d.mercaderia
      end
    end
    m
  end

  def persona_cambiada?
    if persona_id_changed? && self.persisted?
      errors.add(:persona, I18n.t('activerecord.errors.messages.no_editable'))
      false
    end
  end

  private

  def actualizar_boleta
    boletas.first.update_column(:importe_descontado, importe_total)
  end

  def set_importe_total
    self.importe_total = 0
    self.detalles.each do |detalle|
        self.importe_total += detalle.precio_unitario * detalle.cantidad unless detalle.marked_for_destruction?
    end
    self.credito_restante = self.importe_total
  end

   # Actualiza la cuenta corriente si es que se guardo o actualizo
  def actualizar_extracto_de_cuenta_corriente
  	if deleted?
  		CuentaCorrienteExtracto.eliminar_movimiento(self.becomes(NotasCreditosDebito), fecha, importe_total * -1)
  	else
    	CuentaCorrienteExtracto.crear_o_actualizar_extracto(self.becomes(NotasCreditosDebito), fecha, importe_total_was.to_f, importe_total)
  	end
  end
end
