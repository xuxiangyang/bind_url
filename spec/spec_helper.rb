require "bundler/setup"
require "pry"
require "bind_url"
require 'rspec-benchmark'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run_excluding perf: true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end


  config.before(:each) do
    allow_any_instance_of(Aliyun::OSS::Bucket).to receive(:put_object)
  end
end
