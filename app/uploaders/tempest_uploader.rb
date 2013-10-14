# encoding: utf-8

class TempestUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    "uploads/tempests"
  end
  def filename
    @name ||= "#{secure_token}.xml" if original_filename.present?
  end
protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex)
  end
end
