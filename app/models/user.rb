class User < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable


  belongs_to :empleado
  enumerize :rol, in: [:administrador, :superusuario], predicates: true

  validates :username, presence: true
  validates :username, length: {maximum: 20, minimum: 2}
  validates :password, presence: true, on: :create
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z]).+\z/, message: :password_format },  on: :create
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z]).+\z/, message: :password_format },  on: :update, allow_blank: true
  validates_uniqueness_of :username, allow_blank: false

  validate :exists_superuser?

  def email_required?
    false
  end

  def email_changed?
    false
  end

  private

  def exists_superuser?
    if self.rol == :superusuario && User.find_by_rol(:superusuario)
      errors.add(:rol, "de superusuario ya existe y sólo puede existir uno")
    end
  end
end
