# frozen_string_literal: true

require 'rails_helper'

describe MobileWorkflow::ParamParser do
  subject { test_class.new(id) }

  let(:test_class) { Struct.new(:id) { include MobileWorkflow::ParamParser } }

  describe '#mw_rewrite_payload_property' do
    xit 'test'
  end
end
