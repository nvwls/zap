# encoding: UTF-8

require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }
