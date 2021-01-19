require "rails/generators/base"

module MobileWorkflow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      # Schemas to avoid generating models for (static items from MW)
      SKIP_SCHEMAS = ["attachment", "ListItem", "DisplayItem", "DisplayText", "DisplayButton", "DisplayImage", "DisplayVideo"]
      
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
        say "Generating models"
        @model_properties = {}
        open_api_spec[:components][:schemas].each_pair do |model_name, schema|
          next if SKIP_SCHEMAS.include? model_name # Don't generate schemas for MW schemas
        
          model_name = model_name.underscore
          model_properties = model_properties(model_name, schema)
          generate(:model, "#{model_name} #{model_properties}")
          @model_properties[model_name] = model_properties
        end
      end

      def generate_controllers_and_routes
        say "Generating controllers"
        route "root to: 'admin/#{controller_names.first}#index'"
        
        controller_names.each do |plural_controller_name|
          controller_name = plural_controller_name.singularize
          model_properties = @model_properties[controller_name]
          generate "mobile_workflow:controller #{controller_name} --attributes #{model_properties}"
          route "resources :#{plural_controller_name}, only: [:index, :show, :create]"
        end
      end
      
      def generate_seeds
        template("seeds.rb.erb", "db/seeds.rb", force: true)
      end

      private
      def controller_names
        @controller_names ||= oai_spec_paths.collect{|url_path| url_path.split('/')[1] }.uniq
      end
      
      def oai_spec_paths
        @oai_spec_paths ||= open_api_spec[:paths].keys
      end
      
      def open_api_spec
        @open_api_spec ||= read_openapi_spec
      end
      
      def read_openapi_spec
        say "Loading OpenAPI Spec: #{open_api_spec_path}" 
        return JSON.parse(File.read(open_api_spec_path)).with_indifferent_access 
      end
      
      def open_api_spec_path
        options[:open_api_spec_path]
      end
      
      def interactive?
        options[:interactive]
      end
      
      def model_properties(name, schema)
        generated_properties_args = schema["properties"].keys.collect{|key| "#{key}:#{model_property_type(schema["properties"][key])}" }.join(" ")
        if !interactive? || yes?("Use generated schema #{name}(#{generated_properties_args})[yn]?")
          generated_properties_args
        else
          ask "Specify schema for #{name}: (e.g. text:string image:attachment region:reference)"
        end      
      end
      
      def model_property_type(property)
        return property["type"] unless property["type"].blank?
        return 'attachment' if property['$ref'] == "#/components/schemas/attachment"
        
        raise 'Unknown property type'
      end
    end
  end
end