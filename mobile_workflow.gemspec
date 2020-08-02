$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "mobile_workflow/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mobile_workflow"
  spec.version     = MobileWorkflow::VERSION
  spec.authors     = ["Matt Brooke-Smith"]
  spec.email       = ["matt@futureworkshops.com"]
  spec.homepage    = "https://github.com/futureworkshops/mobile_workflow"
  spec.summary     = "A Rails engine to provide API support for Mobile Workflow Apps."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.2"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
end