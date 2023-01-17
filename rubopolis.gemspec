# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubopolis/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 3.0'
  s.name        = 'rubopolis'
  s.version     = Rubopolis::Version::WRAPPER_VERSION
  s.summary     = 'Custom rubocop for Rails project'
  s.description = 'Custom rubocop for Rails project'
  s.authors     = ['Eileen Kang']
  s.email       = 'eileen_kang@tech.gov.sg'
  s.files       = Dir['lib/**/*.rb', 'README.md']
  s.homepage    = 'https://github.com/GovTechSG/rubopolis'
  s.license     = 'MIT'
  s.metadata    = { 'rubygems_mfa_required' => 'true' }

  s.add_development_dependency 'rspec', '~> 3.12'
  s.add_development_dependency 'rubocop', '~> 1.33'
  s.add_development_dependency 'rubocop-rails'
  s.add_development_dependency 'simplecov', '~> 0.22'
  s.add_development_dependency 'timecop'

  s.add_runtime_dependency 'rubocop', '~> 1.33'
  s.add_runtime_dependency 'rubocop-rails'
end
