class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable
         
  belongs_to :persona
  validates :username, presence: true
  validates :username, length: {maximum: 20, minimum: 2}
  validates :password, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*(_|[^\w])).+\z/, message: :password_format }

  validates_uniqueness_of :username, allow_blank: false

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
