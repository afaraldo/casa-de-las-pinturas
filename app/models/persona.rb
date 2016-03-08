class Persona < ActiveRecord::Base
  acts_as_paranoid

  after_initialize :set_limite_credito, if: :new_record?

  validates :nombre, presence: true
  validates :nombre, length: {maximum: 40}
  validates :telefono, length: {maximum: 20}
  validates :direccion, length: {maximum: 200}
  validates :ruc, length: {maximum: 30}
  validates :ruc, presence: true
  validates :limite_credito, numericality: { greater_than_or_equal_to: 0 }

  def set_limite_credito
    self.limite_credito ||= 0
  end
end
