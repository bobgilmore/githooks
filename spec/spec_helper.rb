$:.unshift "#{File.dirname(__FILE__)}/.."
$:.unshift "#{File.dirname(__FILE__)}/../pre_commit"

require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
