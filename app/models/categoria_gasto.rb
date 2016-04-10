class CategoriaGasto < ActiveRecord::Base
	paginates_per 10
  	acts_as_paranoid

	validates :nombre, presence: true
	validates :nombre, length: {maximum: 50, minimum: 2}
	validates :nombre, uniqueness: true

	default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
	scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

end