# encoding: UTF-8

require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::SoloRunner = ChefSpec::Runner if ChefSpec::VERSION.to_f < 4.1

at_exit { ChefSpec::Coverage.report! }
