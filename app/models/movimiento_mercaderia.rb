class MovimientoMercaderia < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  before_destroy :check_detalles_negativos

  has_many :detalles, class_name: 'MovimientoMercaderiaDetalle', dependent: :destroy, inverse_of: :movimiento_mercaderia

  accepts_nested_attributes_for :detalles, reject_if: :all_blank, allow_destroy: true

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
      if d.nueva_cantidad(true) < 0
        m << d.mercaderia
      end
    end

    if m.size > 0
      errors.add(:base, I18n.t('movimiento_mercaderia.eliminar_stock_negativo', mercaderias: m.map{|me| me.nombre}.to_sentence))
      false
    end
  end
end
