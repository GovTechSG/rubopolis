# frozen_string_literal: true

require 'rubocop'

# Original from https://github.com/rubocop/rubocop-rspec/blob/master/lib/rubocop/rspec/inject.rb
module Rubopolis
  # Because RuboCop doesn't yet support plugins, we have to monkey patch in a
  # bit of our configuration.
  module Inject
    def self.defaults!
      path = CONFIG_DEFAULT.to_s
      hash = ::RuboCop::ConfigLoader.send(:load_yaml_configuration, path)
      config = ::RuboCop::Config.new(hash, path).tap(&:make_excludes_absolute)
      puts "configuration from #{path}" if ::RuboCop::ConfigLoader.debug?
      config = ::RuboCop::ConfigLoader.merge_with_default(config, path)
      ::RuboCop::ConfigLoader.instance_variable_set(:@default_configuration, config)
    end
  end
end
