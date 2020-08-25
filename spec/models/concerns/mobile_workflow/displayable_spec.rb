require 'rails_helper'

describe MobileWorkflow::Displayable do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }
  subject { test_class.new(id) }

  describe '#mw_list_item' do
    context 'text' do
      let(:result) { subject.mw_list_item(text: 'London') }
      
      it { expect(result[:id]).to eq 1 }
      it { expect(result[:text]).to eq 'London' }
    end
  end
  
  describe '#mw_display_button' do
    context 'label, url' do
      let(:result) { subject.mw_display_button(label: 'Approve', url: '/approve') }
      
      it { expect(result[:label]).to eq 'Approve' }
      it { expect(result[:url]).to eq '/approve' }
    end
  end
end