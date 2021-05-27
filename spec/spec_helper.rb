Dir[
  "./lib/*.rb",
  "./spec/support/**/*.rb"
].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.tty = true
  config.fail_fast = true
  # config.fail_fast = false
  config.expect_with :rspec do |c|
    c.max_formatted_output_length = 1000000
  end
end
