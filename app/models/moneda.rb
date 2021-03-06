class Moneda < ActiveRecord::Base
  acts_as_paranoid
  validates :nombre, presence: true
  validates :nombre, length: {maximum: 50, minimum: 2}
  validates :nombre, uniqueness: true
  validates :nombre, format: { with: /\A[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+\z/, message: :only_letters_is_allowed }
  validates :cotizacion, presence: true
  validates :cotizacion, numericality: { less_than: 10000000000000, greater_than_or_equal_to: 1 }
  validates :abreviatura, presence: true
  validates :abreviatura, length: {maximum: 5, minimum: 1}
  validates :abreviatura, uniqueness: true
  validates :defecto, inclusion: { in: [true, false] }

  default_scope { order('defecto DESC') }
  scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  after_initialize :set_defecto, if: :new_record?
  def set_defecto
    self.defecto ||= false
  end
end
