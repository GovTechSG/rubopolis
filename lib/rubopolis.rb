# frozen_string_literal: true

require 'pathname'
require 'yaml'

require_relative 'rubopolis/inject'
require_relative 'rubopolis/version'
require_relative 'rubopolis/cop/migration_filename'
require_relative 'rubopolis/cop/query_injection'
require_relative 'rubopolis/cop/time_usage'

##
# Base Module
module Rubopolis
  PROJECT_ROOT = ::Pathname.new(__dir__).parent.expand_path.freeze
  CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze
  CONFIG = ::YAML.safe_load(CONFIG_DEFAULT.read).freeze

  private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)
end

Rubopolis::Inject.defaults!
