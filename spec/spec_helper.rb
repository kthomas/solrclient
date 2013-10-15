require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'spork'

require 'solrclient'

Spork.prefork do

  ENV['RAILS_ENV'] ||= 'test'
  require 'rspec/autorun'
  
  RSpec.configure do |config|

    config.mock_with :mocha

  end

end
