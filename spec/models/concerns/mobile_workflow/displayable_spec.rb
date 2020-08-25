require 'rails_helper'

describe MobileWorkflow::Displayable do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }
  subject { test_class.new(id) }

  describe '#mw_list_item' do
    context 'simple' do
      it { expect(subject.mw_list_item(text: 'London')[:id]).to eq 1 }
      it { expect(subject.mw_list_item(text: 'London')[:text]).to eq 'London' }
    end
  end
end