module MobileWorkflow
  module Generators
    # Custom scaffolding generator
    # https://github.com/rails/rails/blob/master/railties/lib/rails/generators/rails/scaffold_controller/scaffold_controller_generator.rb
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path("../templates", __FILE__)
      
      class_option :attributes, type: :array, default: [], banner: "field:type field:type"
      class_option :actions, type: :array, default: [], banner: "index create update destroy"
      class_option :doorkeeper_oauth, type: :boolean, default: false
      
      def copy_controller_and_spec_files
        template "controller.rb.erb", File.join("app/controllers", controller_class_path, "#{controller_file_name}_controller.rb")
        template "controller_spec.rb.erb", File.join("spec/controllers", controller_class_path, "#{controller_file_name}_controller_spec.rb")
      end
      
      private
      def doorkeeper_oauth?
        options[:doorkeeper_oauth]
      end
      
      def attributes_names
        options[:attributes].map{ |attribute| attribute.split(":").first }
      end
          
      def permitted_params
        params = attributes_names.map{ |name| ":#{name}" }
        params.join(", ")
      end
    end
  end
end