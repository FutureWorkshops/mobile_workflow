shared_examples_for 'styled content grid' do |param|
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
    context 'attachment', if: param[:active_storage_enabled] do
      let(:result) { subject.mw_grid_item(id: 0, text: 'Mountains', detail_text: 'Beautiful landscape', preview_url: preview_url) }
      let(:preview_url) { subject.preview_url(attachment) }
      let(:attachment) { double(ActiveStorage::Attached::One) }

      before(:each) { allow(subject).to receive(:preview_url) { 'https://test.com/preview' } }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'Mountains' }
      it { expect(result[:detailText]).to eq 'Beautiful landscape' }
      it { expect(result[:type]).to eq :item }
      it { expect(result[:imageURL]).to eq 'https://test.com/preview' }
    end

    context 'url' do
      let(:result) { subject.mw_grid_item(id: 0, text: 'Mountains', detail_text: 'Beautiful landscape', preview_url: 'https://test.com/image') }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'Mountains' }
      it { expect(result[:detailText]).to eq 'Beautiful landscape' }
      it { expect(result[:type]).to eq :item }
      it { expect(result[:imageURL]).to eq 'https://test.com/image' }
    end
  end
end
