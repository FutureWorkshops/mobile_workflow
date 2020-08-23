require "rails/generators/base"

module MobileWorkflow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      class_option :open_api_spec_path, type: :string, default: "config/open_api_spec.json"
      class_option :doorkeeper_oauth, type: :boolean, default: false

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
        template("user.rb.erb", "app/models/user.rb")
        template("sessions_controller.rb.erb", "app/controllers/sessions_controller.rb")
        route "resources :sessions, only: [:new, :create]"
      end
      
      def generate_models
        say "Generating models"
        @model_properties = {}
        open_api_spec[:components][:schemas].each_pair do |model_name, schema|
          next if ["answer", "attachment", "ListItem"].include? model_name # Don't generate schemas for MW schemas
        
          model_name = model_name.underscore
          model_properties = model_properties(model_name, schema)
          generate(:model, "#{model_name} #{model_properties}")
          @model_properties[model_name] = model_properties
        end
      end

      def generate_controllers_and_routes
        say "Generating controllers"
        controller_names = open_api_spec[:paths].keys.collect{|url_path| url_path.split('/').last }
      
        route "root to: 'admin/#{controller_names.first}#index'"
        
        controller_names.each do |plural_controller_name|
          controller_name = plural_controller_name.singularize
          model_properties = @model_properties[controller_name]
          generate "mobile_workflow:controller #{controller_name} --attributes #{model_properties}"
          route "resources :#{plural_controller_name}, only: [:index, :show, :create]"
        end
      end

      private
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
      
      def model_properties(name, schema)
        generated_properties_args = schema["properties"].keys.collect{|key| "#{key}:string" }.join(" ")
        if yes?("Use generated schema #{name}(#{generated_properties_args})[yn]?")
          generated_properties_args
        else
          ask "Specify schema for #{name}: (e.g. text:string image:attachment region:reference)"
        end      
      end
    end
  end
end