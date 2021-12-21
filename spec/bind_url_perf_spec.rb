require_relative "./env.rb"
RSpec.describe :bind_url, :perf do
  include RSpec::Benchmark::Matchers

  it "should output 1000 times duration" do
    us = 1000.times.map { |i| User.new(photo: "#{i}.jpg") }

    a = Time.now
    us.each(&:photo_url)
    puts Time.now - a

    a = Time.now
    us.each(&:photo)
    puts Time.now - a
  end
end
