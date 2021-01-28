module MobileWorkflow
  module OpenApiSpec
    class Parser
  
      # Schemas to avoid generating models for (static items from MW)
      SKIP_SCHEMAS = ["attachment", "ListItem", "DisplayItem", "DisplayText", "DisplayButton", "DisplayImage", "DisplayVideo"]
  
      def initialize(open_api_spec_string)
        @open_api_spec_string = open_api_spec_string
      end
  
      def model_name_to_properties
        @model_properties = {}
        schemas.each_pair do |model_name, schema|
          next if SKIP_SCHEMAS.include? model_name # Don't generate schemas for MW schemas
    
          model_name = model_name.underscore
          model_properties = schema_model_properties(model_name, schema)
      
          @model_properties[model_name] = model_properties
        end
        @model_properties
      end
      
      def controller_name_to_actions
        @controller_name_to_actions ||= parse_controller_names_to_actions
      end
  
      def paths
        @paths ||= open_api_spec[:paths].keys
      end
  
      def schemas
        @schemas ||= open_api_spec[:components][:schemas]
      end
  
      private
      def parse_controller_names_to_actions
        controllers = {}
        paths.each do |path|
          path_items = path.split('/')
          controller_name = path_items[1]
          controllers[controller_name] = [] unless controllers.key?(controller_name)
          
          open_api_spec[:paths][path].keys.each do |method|
            controllers[controller_name] << 'create' if path_items.count == 2 && method == 'post'
            controllers[controller_name] << 'index' if path_items.count == 2 && method == 'get'
            controllers[controller_name] << 'show' if path_items.count == 3 && method == 'get'                        
          end
        end
        controllers
      end
      
      def open_api_spec
        @open_api_spec ||= read_openapi_spec
      end
  
      def schema_model_properties(name, schema)
        schema["properties"].keys.collect{|key| "#{key}:#{model_property_type(schema["properties"][key])}" }.join(" ")  
      end
  
      def model_property_type(property)
        return property["type"] unless property["type"].blank?
        return 'attachment' if property['$ref'] == "#/components/schemas/attachment"
    
        raise 'Unknown property type'
      end
  
      def read_openapi_spec
        @read_openapi_spec ||= JSON.parse(@open_api_spec_string).with_indifferent_access 
      end
  
    end
  end
end