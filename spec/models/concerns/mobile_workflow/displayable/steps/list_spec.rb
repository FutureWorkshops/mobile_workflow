require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::List do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_list_item' do
    context 'text' do
      let(:result) { subject.mw_list_item(text: 'London') }

      it { expect(result[:id]).to eq 1 }
      it { expect(result[:text]).to eq 'London' }
    end

    context 'material icon' do
      let(:result) { subject.mw_list_item(text: 'London', material_icon_name: 'star') }

      it { expect(result[:id]).to eq 1 }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:materialIconName]).to eq 'star' }
    end

    context 'image attachment' do
      let(:result) { subject.mw_list_item(text: 'London', image_attachment: attachment) }
      let(:attachment) { attachment_class.new }
      let(:attachment_class) do
        Class.new do
          def attached?
            true
          end
        end
      end

      before(:each) { allow(subject).to receive(:preview_url) { 'https://test.com/preview' } }

      it { expect(result[:id]).to eq 1 }
      it { expect(result[:imageURL]).to eq 'https://test.com/preview' }
    end

    context 'image url' do
      let(:result) { subject.mw_list_item(text: 'London', image_url: 'https://test.com/image') }

      it { expect(result[:id]).to eq 1 }
      it { expect(result[:imageURL]).to eq 'https://test.com/image' }
    end
  end

  describe '#mw_list_search_suggestion' do
    context 'text' do
      let(:result) { subject.mw_list_search_suggestion(id: '1', text: 'London', section_name: 'City') }

      it { expect(result[:id]).to eq "1" }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:sectionName]).to eq 'City' }
    end
  end
end