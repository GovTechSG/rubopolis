# frozen_string_literal: true

require 'rubocop'
require 'rubopolis/inject'
require 'rubocop/rspec/support'

RSpec.configure do |config|
  config.include(RuboCop::RSpec::ExpectOffense)
end
