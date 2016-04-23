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

  # calcula si se va a producir saldo negativo para algunas monedas en la caja efectivo
  def check_detalles_negativos

    monedas = detalles.map(&:moneda_id) # monedas de los detalles
    caja = Caja.get_caja_por_forma(:efectivo) # caja efectivo
    saldos = caja.saldos_por_moneda(monedas) # saldos de esas monedas

    detalles.each do |d|
      saldos[d.moneda_id] -= (d.monto - d.monto_was.to_f)
    end
    monedas_negativas = saldos.map{ |m, v| m if v < 0 }.compact
    monedas_negativas.empty? ? [] : Moneda.find(monedas_negativas) # retorna un conjunto de monedas que pueden quedar con saldo negativo

  end

  def actualizar_extracto
    if fecha_changed?
      detalles.each do |d|
        CajaExtracto.crear_o_actualizar_extracto(d, fecha, d.monto, d.monto)
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
    # Agregar las monedas que no estan presentes
  # esto es para cuando se edita o hay un error al tratar de guardar
  def rebuild_detalles
    build_detalles(detalles.map(&:moneda_id))
  end

end
