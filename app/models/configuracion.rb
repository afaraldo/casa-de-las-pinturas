class Configuracion < ActiveRecord::Base
	mount_uploader :avatar, AvatarUploader
end
