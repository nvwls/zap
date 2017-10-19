require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  config.log_level = ENV.fetch('RSPEC_LOG_LEVEL', 'warn').to_sym
  config.platform = 'centos'
  config.version  = '6.8'
end

ChefSpec::SoloRunner = ChefSpec::Runner if ChefSpec::VERSION.to_f < 4.1

at_exit { ChefSpec::Coverage.report! }
