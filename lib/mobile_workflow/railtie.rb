require 'mobile_workflow'
require 'rails'

module MobileWorkflow
  class Railtie < Rails::Railtie
    railtie_name :mobile_workflow

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end