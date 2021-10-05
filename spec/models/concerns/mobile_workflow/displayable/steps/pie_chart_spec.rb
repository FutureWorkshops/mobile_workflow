require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::PieChart do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  include_examples 'pie chart'
end
