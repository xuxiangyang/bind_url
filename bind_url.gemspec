require_relative 'lib/bind_url/version'

Gem::Specification.new do |spec|
  spec.name          = "bind_url"
  spec.version       = BindUrl::VERSION
  spec.authors       = ["xuxiangyang"]
  spec.email         = ["xxy@xuxiangyang.com"]

  spec.summary       = "rails column bind url with oss"
  spec.description   = "rails column bind url with oss"
  spec.homepage      = "https://github.com/xuxiangyang/bind_url"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/xuxiangyang/bind_url"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_dependency "aliyun-sdk", "> 0.7.0"
  spec.add_dependency "mimemagic", ">= 0.3.0"
  spec.add_dependency "rack", ">= 2.0"
  spec.add_dependency "rest-client", "> 2.0"
  spec.add_development_dependency "pry"
end
