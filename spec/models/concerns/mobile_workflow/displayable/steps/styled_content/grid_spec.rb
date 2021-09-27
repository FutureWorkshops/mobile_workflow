require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::StyledContent::Grid do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_grid_large_section' do
    let(:result) { subject.mw_grid_large_section(id: 0, text: 'Mountains') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'Mountains' }
      it { expect(result[:type]).to eq :largeSection }
    end
  end

  describe '#mw_grid_small_section' do
    let(:result) { subject.mw_grid_small_section(id: 0, text: 'Mountains') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'Mountains' }
      it { expect(result[:type]).to eq :smallSection }
    end
  end

  describe '#mw_grid_item' do
    let(:result) { subject.mw_grid_item(id: 0, text: 'Mountains', detail_text: 'Beautiful landscape', image_attachment: attachment) }
    let(:attachment) { attachment_class.new }
    let(:attachment_class) do
      Class.new do
        def attached?
          true
        end
      end
    end

    context 'ok' do
      before(:each) { allow(subject).to receive(:preview_url) { 'https://test.com/preview' } }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'Mountains' }
      it { expect(result[:detailText]).to eq 'Beautiful landscape' }
      it { expect(result[:type]).to eq :item }
      it { expect(result[:imageURL]).to eq 'https://test.com/preview' }
    end
  end
end
