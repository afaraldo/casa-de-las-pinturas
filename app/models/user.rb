class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable

  belongs_to :persona
  validates :username, presence: true
  validates :username, length: {maximum: 50, minimum: 2}
  validates :password, presence: true, on: :create
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+\z/, message: :password_format },  on: :create
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+\z/, message: :password_format },  on: :update, allow_blank: true
  validates_uniqueness_of :username, allow_blank: false

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
