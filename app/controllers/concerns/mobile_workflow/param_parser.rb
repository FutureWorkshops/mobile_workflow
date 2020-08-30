module MobileWorkflow
  module ParamParser
    def mw_rewrite_payload_properties(model:, properties:)
      properties.each {|property| rewrite_payload_property(model: model, model_property: property, params_property: property)}
    end

    def mw_rewrite_payload_property(model:, model_property:, params_property:)
      params[model][model_property] = params.dig(:payload, params_property, :answer)
    end

    def mw_rewrite_payload_array(model:, model_property:, params_property:)
      answer = params.dig(:payload, params_property, :answer)
      params[model][model_property] = answer[0] if answer
    end    
  end
end

