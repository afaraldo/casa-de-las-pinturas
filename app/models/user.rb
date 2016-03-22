class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :persona
  validates :username, presence: true
  validates :username, length: {maximum: 45, minimum: 2}
  validates_uniqueness_of :username, allow_blank: false

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
