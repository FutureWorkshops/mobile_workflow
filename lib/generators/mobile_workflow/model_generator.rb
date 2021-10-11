require 'rails/generators/active_record/model/model_generator'

module MobileWorkflow
  module Generators

    class ModelGenerator < ActiveRecord::Generators::ModelGenerator
      source_root File.join(File.dirname(ActiveRecord::Generators::ModelGenerator.instance_method(:create_migration_file).source_location.first), "templates")

      class_option :doorkeeper_oauth, type: :boolean, default: false

      def create_model_file
        template File.join(File.dirname(__FILE__), "templates", "model.rb.erb"), File.join('app/models', class_path, "#{file_name}.rb")
      end

      private

      def doorkeeper_oauth?
        options[:doorkeeper_oauth]
      end
    end
  end
end
