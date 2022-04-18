# frozen_string_literal: true

require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::Map do
  subject { test_class.new(id) }

  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  include_examples 'map'
end
