class Moneda < ActiveRecord::Base
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 45, minimum: 2}
  validates :nombre, uniqueness: true
  validates :nombre, format: { with: /\A[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+\z/, message: :only_letters_is_allowed }
  validates :cotizacion, presence: true
  validates :cotizacion, numericality: { less_than: 100000000000000, greater_than_or_equal_to: 0 }
  validates :abreviatura, presence: true
  validates :abreviatura, length: {maximum: 5, minimum: 1}
  validates :abreviatura, uniqueness: true

  default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
  scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  after_initialize :set_defecto, if: :new_record?
  def set_defecto
    self.defecto ||= false
  end
end
