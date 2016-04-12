class Persona < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  has_one :user, dependent: :destroy
  has_many :boletas
  self.inheritance_column = 'tipo'

  has_one :cuenta_corriente_balance, -> { order('anho DESC').order('mes DESC') }, class_name: 'CuentaCorrientePeriodoBalance'

  after_initialize :set_limite_credito, if: :new_record?
  validates :telefono, length: {maximum: 50, minimum: 2}, allow_blank: true
  validates :telefono, format: {with: /\A[^a-zA-Z]+\z/, message: :only_telephone_numbers_is_allowed }, allow_blank: true
  validates :direccion, length: {maximum: 150, minimum: 2}, allow_blank: true
  validates :numero_documento, length: {maximum: 20, minimum: 2}
  validates :numero_documento, presence: true
  validates :limite_credito, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
  scope :by_nombre, lambda { |value| where('lower(nombre) = ?', value.downcase) } # buscar por nombre

  def set_limite_credito
    self.limite_credito ||= 0
  end

  def saldo_actual
    cuenta_corriente_balance.nil? ? 0 : cuenta_corriente_balance.balance
  end
end
