module MobileWorkflow::Cli
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md'
    end
    
    def gemfile
      template 'Gemfile.erb', 'Gemfile'
    end
    
    def procfiles
      copy_file 'Procfile', 'Procfile'
      copy_file 'Procfile.dev', 'Procfile.dev'
    end
    
    def rspec_generator
      generate 'rspec:install'
    end
    
    def factory_bot
      inject_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do
        "\tconfig.include FactoryBot::Syntax::Methods\n"
      end
    end
    
    def migrate_db 
      rails_command("db:drop")
      rails_command("db:create")
      rails_command("db:migrate")
    end

    def administrate_generator
      generate 'administrate:install'
      
      file 'app/assets/config/manifest.js', <<-CODE
//= link administrate/application.css
//= link administrate/application.js
    CODE
  
      file 'app/controllers/admin/application_controller.rb', <<-CODE
module Admin
  class ApplicationController < Administrate::ApplicationController
    http_basic_authenticate_with(name: ENV["ADMIN_USER"], password: ENV["ADMIN_PASSWORD"])
  end
end
CODE

      generate 'administrate:routes'
    end
    
    def active_storage
      rails_command 'active_storage:install'
      copy_file 'storage.s3.yml', 'config/storage.yml'
      gsub_file 'config/environments/production.rb', 'config.active_storage.service = :local', 'config.active_storage.service = :amazon'  
    end
    
    def mobile_workflow_generator(open_api_spec_path)
      copy_file open_api_spec_path, 'config/open_api_spec.json'
      gen_opts = ""
      gen_opts += "--doorkeeper_oauth" if options[:doorkeeper_oauth]
      generate "mobile_workflow:install #{gen_opts}"
    end
    
    def format_source
      `rufo .`
    end
    
    def generate_dot_env
      admin_user = 'admin'
      admin_password = SecureRandom.base64(12)
      
      file '.env', <<-CODE
ADMIN_USER=#{admin_user}
ADMIN_PASSWORD=#{admin_password}
CODE
    end

    def rubocop
      copy_file '.rubocop.yml'
      command = 'rubocop --auto-gen-config'

      puts "Running: #{command}"
      output = `#{command}`
      puts "Output: #{output}"
    end
    
    def simplecov
      append_to_file 'spec/rails_helper.rb', "\n# Config for Test Coverage\nrequire 'simplecov'\nSimpleCov.start\nSimpleCov.minimum_coverage 80\n"
      append_to_file '.gitignore', "\n# Ignore test coverage reports\n/coverage\n"
    end
    
    def rollbar
      generate 'rollbar'
      gsub_file 'config/initializers/rollbar.rb', 'if Rails.env.test?', 'if Rails.env.test? || Rails.env.development?'
      copy_file 'config/initializers/mobile_workflow_rollbar.rb'
      gsub_file 'app/jobs/application_job.rb', 'class ApplicationJob < ActiveJob::Base', "class ApplicationJob < ActiveJob::Base\n  include Rollbar::ActiveJob\n"
    end
    
    def git_commit(message = 'Initial commit')
      git add: "."
      git commit: %Q{ -m '#{message}'}
    end
    
    def s3_backend(region)
      @region = region
      aws_backend.create
      aws_backend.write_env
      
      if options[:heroku]
        heroku_backend.sync_dotenv
        sleep 10 # Wait for the server to restart
        aws_backend.create_topic_subscription(heroku_backend.notifications_endpoint)
      elsif options[:dokku]
        dokku_backend.sync_dotenv 
        aws_backend.create_topic_subscription(dokku_backend.notifications_endpoint)      
      end
      
    end
    
    def heroku
      heroku_backend.create
      heroku_backend.configure_activestorage if options[:s3_storage]
      heroku_backend.deploy
      heroku_backend.seed_db
      heroku_backend.sync_dotenv
    end
    
    def dokku(dokku_host)
      @dokku_host = dokku_host
      dokku_backend.create
      dokku_backend.configure_activestorage if options[:s3_storage]
      dokku_backend.deploy
      dokku_backend.sync_dotenv
    end
    
    private
    def aws_backend
      @aws_backend ||= AwsBackend.new(app_name: app_name, region: @region)
    end
    
    def dokku_backend
      @dokku_backend ||= DokkuBackend.new(app_name: app_name, dokku_host: @dokku_host)
    end
    
    def heroku_backend
      @heroku_backend ||= HerokuBackend.new(app_name: app_name)
    end
  end
end