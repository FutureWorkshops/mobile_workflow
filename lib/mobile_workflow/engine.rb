module MobileWorkflow
  if defined?(Rails)
    class Engine < ::Rails::Engine
      isolate_namespace MobileWorkflow
      
      config.generators do |g|
        g.test_framework :rspec
      end
    end
  end
end
