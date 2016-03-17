class Configuracion < ActiveRecord::Base
	require 'carrierwave/orm/activerecord'
	mount_uploader :avatar, AvatarUploader
	validates :empresa_nombre, presence: true
end
