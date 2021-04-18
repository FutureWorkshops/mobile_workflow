require "rails/generators/base"
require "rails/generators/active_model"
require "rails/generators/active_record/migration"
require "active_record"
require "mobile_workflow/open_api_spec/parser"

module MobileWorkflow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)

      class_option :open_api_spec_path, type: :string, default: "config/open_api_spec.json"
      class_option :doorkeeper_oauth, type: :boolean, default: false
      class_option :s3_storage, type: :boolean, default: false
      class_option :interactive, type: :boolean, default: false

      def create_api_controller
        template("api_controller.rb.erb", "app/controllers/api_controller.rb")
      end
      
      def mount_engine
        route "mount MobileWorkflow::Engine => '/'"
      end
      
      def copy_rake_tasks
        copy_file("lib/tasks/mobile_workflow_doorkeeper.rake") if options[:doorkeeper_oauth]
      end
      
      def generate_doorkeeper
        return unless options[:doorkeeper_oauth]
        say "Generating Doorkeeper OAuth"
        
        migration_template "create_users.rb", "db/migrate/create_users.rb"
        
        generate 'doorkeeper:install'
        gsub_file 'config/initializers/doorkeeper.rb', 'raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"', 'User.find_by_id(session[:user_id]) || redirect_to(new_session_url(return_to: request.fullpath))'
        generate 'doorkeeper:migration'
        generate 'doorkeeper:pkce'
        template("user.rb.erb", "app/models/user.rb")
        template("sessions_controller.rb.erb", "app/controllers/sessions_controller.rb")
        route "resources :sessions, only: [:new, :create]"
        
        # View related for login screen
        copy_file("app/views/layouts/application.html.erb")
        copy_file("app/views/sessions/new.html.erb")
        copy_file("app/helpers/application_helper.rb")
        copy_file("spec/factories/users.rb")
      end
      
      def generate_models
        say "Loading OpenAPI Spec: #{open_api_spec_path}"
        say "Generating models"
        
        copy_file("app/models/application_record.rb")
        
        model_name_to_properties.each_pair do |model_name, model_properties|   
          
          if doorkeeper_oauth?
            model_properties = "#{model_properties} user:references"
            @model_name_to_properties[model_name] = model_properties
          end
                 
          if interactive? && !yes?("Use generated schema #{model_name}(#{model_properties})[yn]?")
            model_properties = ask "Specify schema for #{model_name}: (e.g. text:string image:attachment region:reference)"
            @model_name_to_properties[model_name] = model_properties
          end

          generate_model(model_name, model_properties)
        end
      end

      def generate_controllers_and_routes
        say "Generating controllers"
        controller_name_to_actions = open_api_spec.controller_name_to_actions
        route "root to: 'admin/#{controller_name_to_actions.keys.first}#index'"
        
        controller_name_to_actions.each_pair do |plural_controller_name, actions|
          controller_name = plural_controller_name.singularize
          model_properties = model_name_to_properties[controller_name]
          
          unless model_properties
            # Generate a model because it probably wasnt present in the schema
            # And set default attributes
            model_properties = "text:string"
            generate_model(controller_name, model_properties)
          end
          
          generate "mobile_workflow:controller #{controller_name} --actions #{actions.join(" ")} --attributes #{model_properties} #{generate_controller_args}".strip
          route "resources :#{plural_controller_name}, only: [#{actions.map{|a| ":#{a}"}.join(", ")}]"
        end
      end
      
      def generate_seeds
        template("seeds.rb.erb", "db/seeds.rb", force: true)
      end

      private
      
      def generate_model(model_name, model_properties)
        generate("mobile_workflow:model #{model_name} #{model_properties}")
      end
      
      def generate_controller_args
        args = ''
        args += ' --s3-storage' if s3_storage?
        args += ' --doorkeeper-oauth' if doorkeeper_oauth?
        args.strip
      end
      
      def model_name_to_properties
        @model_name_to_properties ||= open_api_spec.model_name_to_properties
      end
      
      def open_api_spec
        @open_api_spec ||= ::MobileWorkflow::OpenApiSpec::Parser.new(File.read(open_api_spec_path))
      end

      def doorkeeper_oauth?
        options[:doorkeeper_oauth]
      end
      
      def s3_storage?
        options[:s3_storage]
      end
      
      def open_api_spec_path
        options[:open_api_spec_path]
      end
      
      def interactive?
        options[:interactive]
      end
    end
  end
end