require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::List do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Attachable, MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  include_examples 'list', { active_storage_enabled: true }
end
