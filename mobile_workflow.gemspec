# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'mobile_workflow/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'mobile_workflow'
  spec.version     = MobileWorkflow::VERSION
  spec.authors     = ['Matt Brooke-Smith']
  spec.email       = ['matt@futureworkshops.com']
  spec.homepage    = 'https://github.com/futureworkshops/mobile_workflow'
  spec.summary     = 'A Rails engine to provide API support for Mobile Workflow Apps.'
  spec.license     = 'MIT'
  spec.required_ruby_version = ">= #{MobileWorkflow::RUBY_VERSION}"

  spec.files = Dir['{app,config,db,lib,bin}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.executables = ['mwf']

  spec.add_dependency 'app_rail-steps', '~> 0.2.4'
  spec.add_dependency 'aws-sdk-s3', '~> 1.60', '>= 1.60.1'
  spec.add_dependency 'aws-sdk-sns', '~> 1.23'
  spec.add_dependency 'rails', ">= #{MobileWorkflow::RAILS_VERSION}", '< 7'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
