require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::Map do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_map_item' do
    context 'text' do
      let(:result) { subject.mw_map_item(text: 'London', latitude: 20.1, longitude: 10.1) }

      it { expect(result[:id]).to eq "1" }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:latitude]).to eq 20.1 }
      it { expect(result[:longitude]).to eq 10.1 }
    end
  end
end
