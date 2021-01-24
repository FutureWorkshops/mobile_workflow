require "rails/generators/base"
require "mobile_workflow/open_api_spec/parser"

module MobileWorkflow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      class_option :open_api_spec_path, type: :string, default: "config/open_api_spec.json"
      class_option :doorkeeper_oauth, type: :boolean, default: false
      class_option :interactive, type: :boolean, default: false

      def create_api_controller
        template("api_controller.rb.erb", "app/controllers/api_controller.rb")
      end
      
      def mount_engine
        route "mount MobileWorkflow::Engine => '/'"
      end
      
      def generate_doorkeeper
        return unless options[:doorkeeper_oauth]
        say "Generating Doorkeeper OAuth"
        
        generate 'doorkeeper:install'
        gsub_file 'config/initializers/doorkeeper.rb', 'raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"', 'User.find_by_id(session[:user_id]) || redirect_to(new_session_url(return_to: request.fullpath))'
        generate 'doorkeeper:migration'
        generate 'doorkeeper:pkce'
        template("user.rb.erb", "app/models/user.rb")
        template("sessions_controller.rb.erb", "app/controllers/sessions_controller.rb")
        route "resources :sessions, only: [:new, :create]"
        
        # View related for login screen
        copy_file("views/layouts/application.html.erb")
        copy_file("views/sessions/new.html.erb")
        copy_file("helpers/application_helper.rb")
      end
      
      def generate_models
        say "Loading OpenAPI Spec: #{open_api_spec_path}"
        say "Generating models"
        model_name_to_properties.each_pair do |model_name, model_properties|          
          if interactive? && !yes?("Use generated schema #{model_name}(#{model_properties})[yn]?")
            model_properties = ask "Specify schema for #{model_name}: (e.g. text:string image:attachment region:reference)"
          end

          generate_model(model_name, model_properties)
          @model_name_to_properties[model_name] = model_properties
        end
      end

      def generate_controllers_and_routes
        say "Generating controllers"
        route "root to: 'admin/#{open_api_spec.controller_names.first}#index'"
        
        open_api_spec.controller_names.each do |plural_controller_name|
          controller_name = plural_controller_name.singularize
          model_properties = model_name_to_properties[controller_name]
          
          unless model_properties
            # Generate a model because it probably wasnt present in the schema
            # And set default attributes
            model_properties = "text:string"
            generate_model(controller_name, model_properties)
          end
          
          generate "mobile_workflow:controller #{controller_name} --attributes #{model_properties}"
          route "resources :#{plural_controller_name}, only: [:index, :show, :create]"
        end
      end
      
      def generate_seeds
        template("seeds.rb.erb", "db/seeds.rb", force: true)
      end

      private
      
      def generate_model(model_name, model_properties)
        generate("mobile_workflow:model #{model_name} #{model_properties}")
      end
      
      def model_name_to_properties
        @model_name_to_properties ||= open_api_spec.model_name_to_properties
      end
      
      def open_api_spec
        @open_api_spec ||= ::MobileWorkflow::OpenApiSpec::Parser.new(File.read(open_api_spec_path))
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