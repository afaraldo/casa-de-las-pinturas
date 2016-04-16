class Persona < ActiveRecord::Base
  self.inheritance_column = 'tipo'

  acts_as_paranoid
  has_paper_trail

  after_initialize :set_limite_credito, if: :new_record?

  has_one :user, dependent: :destroy
  has_many :boletas, foreign_key: 'persona_id', inverse_of: :persona
  has_one :cuenta_corriente_balance, -> { order('anho DESC').order('mes DESC') }, class_name: 'CuentaCorrientePeriodoBalance'

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

  # Incluir el saldo actual en las busquedas por ajax
  def as_json(options={})
    super(:methods => [:saldo_actual])
  end

end
