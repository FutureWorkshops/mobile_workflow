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

    def administrate_generator
      Bundler.with_unbundled_env { generate 'administrate:install' }
      
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

      Bundler.with_unbundled_env { generate 'administrate:routes' }
    end
    
    def ability_generator
      copy_file 'ability.rb', 'app/models/ability.rb'
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
      
      # Copy user migrations if needed
      rails_command 'mobile_workflow:install:migrations' if options[:doorkeeper_oauth]
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