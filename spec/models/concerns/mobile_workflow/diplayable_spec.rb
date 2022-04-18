require 'spec_helper'
require 'mobile_workflow/displayable'

# This file tests the module without using Rails
describe MobileWorkflow::Displayable do
  let(:test_struct) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:test_class) { Class.new { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_struct.new(id) }

  include_examples 'styled content grid', { active_storage_enabled: false }
  include_examples 'styled content stack', { active_storage_enabled: false }
  include_examples 'form'
  include_examples 'list', { active_storage_enabled: false }
  include_examples 'map'
  include_examples 'question'
  include_examples 'stack', { active_storage_enabled: false }
end
