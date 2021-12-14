require "bind_url/version"
require "bind_url/binder"
require "bind_url/bucket_config"

module BindUrl
  BindUrlConfig = Struct.new(:binder_class, :private, keyword_init: true)
  class Error < StandardError; end

  def bind_url(attr, binder_class, private: false)
    bind_url_configs[attr.to_sym] = BindUrlConfig.new(binder_class: binder_class, private: private)

    self.class_eval <<-RUBY, __FILE__, __LINE__+1
      def #{attr}_url
        _#{attr}_binder.url
      end

      def #{attr}_url=(url)
        _#{attr}_binder.url = url
      end

      def #{attr}_file=(file)
        _#{attr}_binder.file = file
      end

      def _#{attr}_binder
        config = self.class.bind_url_configs[:#{attr}]
        config.binder_class.new(model: self, attr: :#{attr}, private: config.private)
      end
    RUBY
  end

  def bind_urls(attr, binder_class, private: false)
    @bind_url_configs ||= {}
    @bind_url_configs[attr] = BindUrlConfig.new(binder_class: binder_class, private: private)
  end

  def bind_url_configs
    @bind_url_configs ||= {}
  end

  class << self
    attr_accessor :storage_configs

    def configure(storage = :default)
      config = BindUrl::BucketConfig.new
      yield config
      storage_configs[storage] = config
    end
  end
end

BindUrl.storage_configs = {}
