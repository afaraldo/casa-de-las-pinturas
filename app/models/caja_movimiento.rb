class CajaMovimiento < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  before_destroy :check_detalles_negativos
  after_save :actualizar_extracto

  belongs_to :categoria_gasto, -> { with_deleted }

  after_save :actualizar_extracto

  has_many :detalles, class_name: 'CajaMovimientoDetalle', dependent: :destroy, inverse_of: :caja_movimiento

  delegate :nombre, to: :categoria_gasto, prefix: true

  accepts_nested_attributes_for :detalles, reject_if: proc { |attrs| (attrs['monto'].to_f) <= 0 }, allow_destroy: true

  enumerize :tipo, in: [:ingreso, :egreso], predicates: true

  default_scope { order('fecha DESC') } # Ordenar por fecha por defecto

  validates :fecha,  presence: true
  validates :motivo, presence: true, length: {maximum: 255, minimum: 2}
  validates :tipo,   presence: true
  validates :detalles, length: { minimum: 1 }
  validate  :fecha_futura

  def fecha_futura
    if fecha > Date.today
      errors.add(:fecha, I18n.t('activerecord.errors.messages.fecha_futura'))
    end
  end

  def check_detalles_negativos
    m = []
    detalles.each do |d|
      if d.nueva_monto(true) < 0
        m << d.caja_saldos
      end
    end

    if m.size > 0
      errors.add(:base, I18n.t('caja_movimiento.eliminar_saldo_negativo', caja_saldos: m.map{|me| me.nombre}.to_sentence))
      false
    end
  end

  def actualizar_extracto
    if fecha_changed?
      detalles.each do |d|
        CajaExtracto.crear_o_actualizar_extracto(d, fecha, d.cantidad, d.cantidad)
      end
    end
  end

  def build_detalles(monedas_usadas = [])
    Moneda.all.each do |m|
      unless monedas_usadas.include?(m.id)
        detalles.build(moneda: m, forma: :efectivo, monto: 0)
      end
    end
  end

end
