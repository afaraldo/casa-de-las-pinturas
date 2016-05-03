class CajaMovimiento < ActiveRecord::Base
  extend Enumerize
  include SqlHelper

  acts_as_paranoid

  before_validation :set_importe_total
  before_destroy :check_detalles_negativos
  after_save :actualizar_extracto

  belongs_to :categoria_gasto

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
  validates :categoria_gasto, presence: true, if: :egreso?

  def set_importe_total
    self.importe_total = 0

    detalles.each do |d|
      self.importe_total += d.monto * d.cotizacion
    end
  end

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
        detalles.build(moneda: m, forma: :efectivo, monto: 0, cotizacion: m.cotizacion)
      end
    end
  end

  # Agregar las monedas que no estan presentes
  # esto es para cuando se edita o hay un error al tratar de guardar
  def rebuild_detalles
    build_detalles(detalles.map(&:moneda_id))
  end

  def self.reporte_gastos(*args)

    opciones = args.extract_options!

    opciones[:agrupar_por] = 'dia' if opciones[:agrupar_por].nil?
    opciones[:order_by] = 'grupo' if opciones[:order_by].nil?
    opciones[:order_dir] = 'asc' if opciones[:order_dir].nil?

    resultado = self.unscoped.where(deleted_at: nil, tipo: :egreso).where(fecha: opciones[:desde]..opciones[:hasta])

    resultado = resultado.where(categoria_gasto_id: opciones[:categoria_gasto_id]) unless opciones[:categoria_gasto_id].blank?

    grupo_formato = (opciones[:agrupar_por] == 'dia') ? 'default' : opciones[:agrupar_por]

    if opciones[:resumido]
      grupo = opciones[:agrupar_por] == 'categoria' ? 'categoria_gastos.nombre' : "to_char(fecha, '#{SQL_PERIODOS[opciones[:agrupar_por].to_sym]}')"

      resultado.joins(:categoria_gasto)
                .select("#{grupo} as grupo, sum(importe_total) as total")
                .order("#{opciones[:order_by]} #{opciones[:order_dir]}")
                .group("#{grupo}")
                .page(opciones[:page]).per(opciones[:limit])

    else
      resultado = resultado.includes(:categoria_gasto)
                           .order("#{(opciones[:agrupar_por] == 'categoria') ? 'categoria_gastos.nombre' : 'fecha'} asc")
                           .page(opciones[:page]).per(opciones[:limit])

      {todo: resultado, agrupado: resultado.group_by { |b| (opciones[:agrupar_por] == 'categoria') ? b.categoria_gasto_nombre :  I18n.localize(b.fecha.to_date, format: grupo_formato.to_sym).capitalize }}
    end

  end

end
