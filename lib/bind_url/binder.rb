require 'rest-client'
require 'mimemagic'
require 'securerandom'
require 'pathname'
require 'aliyun/oss'
require 'rack'
require "active_support/core_ext/string/inflections"


module BindUrl
  class Binder
    attr_accessor :model, :attr, :private

    def initialize(model:, attr:, private:)
      @model = model
      @attr = attr
      @private = private
    end

    def store_dir
      raise "need overwrite"
    end

    def gen_url(v, parameters = {})
      parameters = parameters.map { |key, value| [key.to_s, value.to_s] }.to_h
      uri = URI(self.class.oss_bucket.object_url(File.join(store_dir, v).gsub(%r{^/}, ""), self.private, 7200, parameters))
      host_uri = URI(self.class.storage_config.host)
      uri.scheme = host_uri.scheme
      uri.host = host_uri.host
      uri.to_s
    end

    def upload_via_url(url)
      upload_via_file(download_as_tmp_file(url))
    end

    def upload_via_file(file)
      extname = Pathname.new(file.path).extname
      filename = "#{SecureRandom.uuid.delete('-')}#{extname}"
      self.class.oss_bucket.put_object(
        File.join(store_dir, filename),
        file: file.path,
        content_type: Rack::Mime::MIME_TYPES[extname] || MimeMagic.by_magic(file).type,
        acl: self.private ? "private" : "default",
      )
      filename
    end

    private

    def download_as_tmp_file(url)
      res = RestClient.get(url)
      file = Tempfile.new(["", Rack::Mime::MIME_TYPES.invert[res.headers[:content_type]]])
      file.binmode
      file.write(res.body)
      file.flush
      file
    end

    class << self
      def storage(val = nil)
        if val
          @storage = val
        else
          @storage || :default
        end
      end

      def storage_config
        BindUrl.storage_configs[storage]
      end

      def oss_bucket
        return @oss_bucket if @oss_bucket
        c = Aliyun::OSS::Client.new(
          endpoint: storage_config.endpoint,
          access_key_id: storage_config.access_key_id,
          access_key_secret: storage_config.access_key_secret,
        )
        @oss_bucket = c.get_bucket(storage_config.bucket)
      end
    end
  end
end
