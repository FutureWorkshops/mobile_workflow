# frozen_string_literal: true

require 'mobile_workflow/deprecated'
require 'mobile_workflow/engine'

module MobileWorkflow
  require 'mobile_workflow/railtie' if defined?(Rails)
end
