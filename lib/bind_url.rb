require "bind_url/version"
require "bind_url/binder"
require "bind_url/bucket_config"
require "active_support/all"

module BindUrl
  BindUrlConfig = Struct.new(:binder_class, :private, keyword_init: true)
  class Error < StandardError; end

  def bind_url(attr, binder_class, private: false)
    bind_url_configs[attr.to_sym] = BindUrlConfig.new(binder_class: binder_class, private: private)

    self.class_eval <<-RUBY, __FILE__, __LINE__+1
      def #{attr}_url(params = {})
        v = self.send(:#{attr})
        return nil unless v
        #{attr}_binder.gen_url(v, params)
      end

      def #{attr}_url=(url)
        self.send("#{attr}=", #{attr}_binder.upload_via_url(url))
      end

      def #{attr}_file=(file)
        self.send("#{attr}=", #{attr}_binder.upload_via_file(file))
      end

      def #{attr}_binder
        config = self.class.bind_url_configs[:#{attr}]
        config.binder_class.new(model: self, attr: :#{attr}, private: config.private)
      end
    RUBY
  end

  def bind_urls(attr, binder_class, private: false)
    bind_url_configs[attr.to_sym] = BindUrlConfig.new(binder_class: binder_class, private: private)

    signle_attr = attr.to_s.singularize.to_sym
    self.class_eval <<-RUBY, __FILE__, __LINE__+1
      def #{signle_attr}_urls(params = {})
        vs = self.send(:#{attr})
        return [] if vs.nil?
        vs.map { |v| #{attr}_binder.gen_url(v, params) }.freeze
      end

      def #{signle_attr}_urls=(urls)
        vs = urls.map { |url| #{attr}_binder.upload_via_url(url) }
        self.send("#{attr}=", vs)
      end

      def #{signle_attr}_files=(files)
        vs = files.map { |f| #{attr}_binder.upload_via_file(f) }
        self.send("#{attr}=", vs)
      end

      def upload_#{signle_attr}_url(index, url)
        vs = self.send("#{attr}") || []
        vs[index] = #{attr}_binder.upload_via_url(url)
        self.send("#{attr}=", vs)
      end

      def upload_#{signle_attr}_file(index, file)
        vs = self.send("#{attr}") || []
        vs[index] = #{attr}_binder.upload_via_file(file)
        self.send("#{attr}=", vs)
      end

      def #{attr}_binder
        config = self.class.bind_url_configs[:#{attr}]
        config.binder_class.new(model: self, attr: :#{attr}, private: config.private)
      end
    RUBY
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
