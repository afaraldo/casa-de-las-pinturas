class Categoria < ActiveRecord::Base
  paginates_per 10
  acts_as_paranoid

  before_destroy :check_subcategorias
  before_destroy :check_mercaderias

  has_many :subcategorias, class_name: 'Categoria',
           foreign_key: 'categoria_padre_id'
  has_many :mercaderias
  belongs_to :padre, class_name: 'Categoria',
             foreign_key: 'categoria_padre_id'

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 50, minimum: 2}
  validates :nombre, uniqueness: true

  default_scope { order('nombre') } # Ordenar por nombre por defecto
  scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  scope :padres, lambda { |self_id = nil| where(categoria_padre_id: nil).where.not(id: self_id) } # busca los que sean padres y no tengan el id pasado como parametro

  # si tiene subcategorias no se puede eliminar
  def check_subcategorias
    if subcategorias.size > 0
      errors.add(:base, I18n.t("categoria.tiene_subcategorias_error"))
      false
    end
  end

  def check_mercaderias
    if mercaderias.size > 0
      errors.add(:base, I18n.t("categoria.mercaderias_dependientes_error"))
      false
    end
  end
end
