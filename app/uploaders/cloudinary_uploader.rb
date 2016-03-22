class CloudinaryUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  process :convert => 'png'

  version :thumbnail do
    resize_to_fit(150, 150)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end