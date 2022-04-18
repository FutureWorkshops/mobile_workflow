# frozen_string_literal: true

require 'mobile_workflow/deprecated'
require 'mobile_workflow/engine'
require 'mobile_workflow/displayable'

module MobileWorkflow
  require 'mobile_workflow/railtie' if defined?(Rails)
end
