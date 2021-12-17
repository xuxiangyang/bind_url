require 'bind_url'
BindUrl.configure do |config|
  config.endpoint = "oss-cn-hangzhou.aliyuncs.com"
  config.access_key_id = "access_key_id"
  config.access_key_secret = "access_key_secret"
  config.bucket = "example"
  config.host = "https://oss.example.com"
end

BindUrl.configure(:other_storage) do |config|
  config.endpoint = "oss-cn-hangzhou.aliyuncs.com"
  config.access_key_id = "access_key_id"
  config.access_key_secret = "access_key_secret"
  config.bucket = "example2"
  config.host = "https://oss2.example.com"
end

class ImageBinder < BindUrl::Binder
  def store_dir
    "#{self.model.class}/#{self.attr}"
  end
end
BindUrl.default_binder_class = ImageBinder

class OtherBinder < BindUrl::Binder
  storage :other_storage
  def store_dir
    "other"
  end
end

class User
  extend BindUrl

  attr_accessor :photo, :private_photo, :other, :pictures, :private_pictures, :others
  def initialize(photo: nil, private_photo: nil, other: nil, pictures: [], private_pictures: [], others: [])
    @photo = photo
    @private_photo = private_photo
    @other = other
    @pictures = pictures
    @private_pictures = private_pictures
    @others = others
  end

  bind_url :photo
  bind_url :private_photo, private: true
  bind_url :other, binder_class: OtherBinder
  bind_urls :pictures
  bind_urls :private_pictures, private: true
end
