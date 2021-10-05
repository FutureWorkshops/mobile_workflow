require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::Form do
  let(:test_class) { Class.new { include MobileWorkflow::Displayable } }

  include_examples 'form'
end
