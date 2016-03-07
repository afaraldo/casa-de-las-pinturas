class Persona < ActiveRecord::Base
  validates :nombre, presence: true
end
