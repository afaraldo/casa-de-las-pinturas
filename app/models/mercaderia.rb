class Mercaderia < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid

  belongs_to :categoria, -> { with_deleted }

  delegate :nombre, to: :categoria, prefix: true

  enumerize :unidad_de_medida, in: [:unidad, :metro, :litro, :kilo], predicates: true

  validates :nombre, presence: true, length: {maximum: 50, minimum: 2}
  validates :codigo, presence: true, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :categoria_id, presence: true
  validates :descripcion, length: {maximum: 150, minimum: 2}, allow_blank: true
  validates :unidad_de_medida, presence: true
  validates :precio_venta_contado, numericality: { greater_than_or_equal_to: 0 }
  validates :precio_venta_credito, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_minimo,         numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: true

  default_scope { order('lower(nombre)') } # Ordenar por nombre por defecto
  scope :by_codigo, lambda { |value| where('lower(codigo) = ?', value.downcase) } # buscar por codigo

  def actualizar_stock(cantidad, tipo_movimiento)
    self.stock += cantidad if tipo_movimiento == :ingreso
    self.stock -= cantidad if tipo_movimiento == :egreso
    save
  end

end
