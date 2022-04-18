# frozen_string_literal: true

require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::List do
  subject { test_class.new(id) }

  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Attachable, MobileWorkflow::Displayable } }
  let(:id) { 1 }

  include_examples 'list', { active_storage_enabled: true }
end
