class CategoriaGasto < ActiveRecord::Base
  acts_as_paranoid

  before_destroy :check_caja_movimientos

  has_many :caja_movimientos

	validates :nombre, presence: true
	validates :nombre, length: {maximum: 50, minimum: 2}
	validates :nombre, uniqueness: true

	default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
	scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  def check_caja_movimientos
    if caja_movimientos.size > 0
      errors.add(:base, I18n.t("categoria_gasto.caja_movimientos_dependientes_error"))
      false
    end
  end

end
