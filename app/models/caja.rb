class Caja < ActiveRecord::Base

  acts_as_paranoid

  validates :nombre, presence: true, length: {maximum: 50, minimum: 2}
  
  default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
  scope :by_codigo, lambda { |value| where('lower(codigo) = ?', value.downcase) } # buscar por codigo

  def self.get_caja_por_forma(forma)
    find_by('lower(nombre) = ?', forma)
  end
end
