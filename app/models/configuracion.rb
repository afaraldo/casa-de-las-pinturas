class Configuracion < ActiveRecord::Base
	require 'carrierwave/orm/activerecord'
	mount_uploader :avatar, AvatarUploader
	validates :empresa_nombre, presence: true, length: {maximum: 50, minimum: 2}
	validates :empresa_direccion, presence: true, length: {maximum: 150, minimum: 2}
	validates :empresa_telefono, length: {maximum: 150}
	validates :empresa_email, length: {maximum: 50}
end

