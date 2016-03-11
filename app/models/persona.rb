class Persona < ActiveRecord::Base
  acts_as_paranoid

  self.inheritance_column = 'tipo'

  after_initialize :set_limite_credito, if: :new_record?

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 150, minimum: 2}
  validates :telefono, length: {maximum: 50, minimum: 2}
  validates :direccion, length: {maximum: 150, minimum: 2}
  validates :numero_documento, length: {maximum: 50, minimum: 2}
  validates :numero_documento, presence: true
  validates :limite_credito, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order('nombre') } # Ordenar por nombre por defecto
  scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  def set_limite_credito
    self.limite_credito ||= 0
  end
end
