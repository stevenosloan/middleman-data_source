require 'rspec'
require 'rack/test'
require 'middleman'

require_relative 'support/given'
require_relative 'support/fixture'
require_relative 'support/browser'

if ENV['DEBUG']
  require 'pry'
end

RSpec.configure do |c|

  c.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles        = true
  end

end

def tracer msg
  STDOUT.puts "\n\n==========================\n\n#{msg}\n\n==========================\n"
end

require 'middleman-data_source'
