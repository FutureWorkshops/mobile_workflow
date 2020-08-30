require 'rails_helper'

describe MobileWorkflow::ParamParser do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::ParamParser } }
  subject { test_class.new(id) }

  describe '#mw_rewrite_payload_property' do
    xit 'test'
  end
end