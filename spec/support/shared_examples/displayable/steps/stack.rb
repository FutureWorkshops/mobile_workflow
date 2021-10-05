shared_examples_for 'stack' do |param|
  describe '#mw_display_text' do
    let(:result) { subject.mw_display_text(text: 'London', label: 'City') }

    it { expect(result[:type]).to eq :text }
    it { expect(result[:text]).to eq 'London' }
    it { expect(result[:label]).to eq 'City' }
  end

  describe '#mw_display_image' do
    context 'attachment', if: param[:active_storage_enabled] do
      let(:result) { subject.mw_display_image(preview_url: preview_url, attachment_url: attachment_url) }
      let(:preview_url) { subject.preview_url(attachment) }
      let(:attachment_url) { subject.attachment_url(attachment) }
      let(:attachment) { double(ActiveStorage::Attached::One) }

      before(:each) do
        allow(subject).to receive(:preview_url) { 'https://test.com/preview' }
        allow(subject).to receive(:attachment_url) { 'https://test.com/attachment' }
      end

      it { expect(result[:type]).to eq :image }
      it { expect(result[:contentMode]).to eq 'scaleAspectFill' }
      it { expect(result[:previewURL]).to eq 'https://test.com/preview' }
      it { expect(result[:url]).to eq 'https://test.com/attachment' }
    end

    context 'url' do
      let(:result) { subject.mw_display_image(preview_url: 'https://test.com/preview', attachment_url: 'https://test.com/attachment') }

      it { expect(result[:type]).to eq :image }
      it { expect(result[:contentMode]).to eq 'scaleAspectFill' }
      it { expect(result[:previewURL]).to eq 'https://test.com/preview' }
      it { expect(result[:url]).to eq 'https://test.com/attachment' }
    end
  end

  describe '#mw_display_unsplash_image' do
    let(:result) { subject.mw_display_unsplash_image('https://unsplash.com/photos/100') }

    it { expect(result[:type]).to eq :image }
    it { expect(result[:previewURL]).to eq 'https://source.unsplash.com/100/800x600' }
    it { expect(result[:url]).to eq 'https://source.unsplash.com/100/800x600' }
  end

  describe '#mw_display_video' do
    context 'attachment', if: param[:active_storage_enabled] do
      let(:result) { subject.mw_display_video(preview_url: preview_url, attachment_url: attachment_url) }
      let(:preview_url) { subject.preview_url(attachment) }
      let(:attachment_url) { subject.attachment_url(attachment) }
      let(:attachment) { double(ActiveStorage::Attached::One) }

      before(:each) do
        allow(subject).to receive(:preview_url) { 'https://test.com/preview' }
        allow(subject).to receive(:attachment_url) { 'https://test.com/attachment' }
      end

      it { expect(result[:type]).to eq :video }
      it { expect(result[:previewURL]).to eq 'https://test.com/preview' }
      it { expect(result[:url]).to eq 'https://test.com/attachment' }
    end

    context 'url' do
      let(:result) { subject.mw_display_video(preview_url: 'https://test.com/preview', attachment_url: 'https://test.com/attachment') }

      it { expect(result[:type]).to eq :video }
      it { expect(result[:previewURL]).to eq 'https://test.com/preview' }
      it { expect(result[:url]).to eq 'https://test.com/attachment' }
    end
  end

  describe '#mw_display_button' do
    let(:result) { subject.mw_display_button(label: 'Sign Up', style: :outline, on_success: :forward, sf_symbol_name: 'Person', material_icon_name: 'Person') }

    it { expect(result[:type]).to eq :button }
    it { expect(result[:label]).to eq 'Sign Up' }
    it { expect(result[:style]).to eq :outline }
    it { expect(result[:onSuccess]).to eq :forward }
    it { expect(result[:sfSymbolName]).to eq 'Person' }
    it { expect(result[:materialIconName]).to eq 'Person' }
  end

  describe '#mw_display_delete_button' do
    let(:result) { subject.mw_display_delete_button(url: 'https://test.com/delete', label: 'Delete') }

    it { expect(result[:type]).to eq :button }
    it { expect(result[:label]).to eq 'Delete' }
    it { expect(result[:style]).to eq :danger }
    it { expect(result[:onSuccess]).to eq :backward }
    it { expect(result[:sfSymbolName]).to eq 'trash' }
    it { expect(result[:materialIconName]).to eq 'delete' }
    it { expect(result[:url]).to eq 'https://test.com/delete' }
    it { expect(result[:method]).to eq :delete }
  end

  describe '#mw_display_url_button' do
    let(:result) { subject.mw_display_url_button(url: 'https://test.com/update', label: 'Update', method: :put, style: :outline, confirm_title: 'Confirm', confirm_text: 'Are you sure?', on_success: :forward) }

    it { expect(result[:type]).to eq :button }
    it { expect(result[:label]).to eq 'Update' }
    it { expect(result[:style]).to eq :outline }
    it { expect(result[:onSuccess]).to eq :forward }
    it { expect(result[:url]).to eq 'https://test.com/update' }
    it { expect(result[:method]).to eq :put }
    it { expect(result[:confirmTitle]).to eq 'Confirm' }
    it { expect(result[:confirmText]).to eq 'Are you sure?' }
  end

  describe '#mw_display_system_url_button' do
    let(:result) { subject.mw_display_system_url_button(label: 'Open Link', apple_system_url: 'https://test.com/open', android_deep_link: 'https://test.com/open', style: :primary, sf_symbol_name: 'World', material_icon_name: 'World') }

    it { expect(result[:type]).to eq :button }
    it { expect(result[:label]).to eq 'Open Link' }
    it { expect(result[:style]).to eq :primary }
    it { expect(result[:appleSystemURL]).to eq 'https://test.com/open' }
    it { expect(result[:androidDeepLink]).to eq 'https://test.com/open' }
    it { expect(result[:sfSymbolName]).to eq 'World' }
    it { expect(result[:materialIconName]).to eq 'World' }
  end

  describe '#mw_display_modal_workflow_button' do
    let(:result) { subject.mw_display_modal_workflow_button(label: 'Log In', modal_workflow_name: 'Log In', style: :primary, on_success: :none, sf_symbol_name: 'Login', material_icon_name: 'Login') }

    it { expect(result[:type]).to eq :button }
    it { expect(result[:label]).to eq 'Log In' }
    it { expect(result[:modalWorkflow]).to eq 'Log In' }
    it { expect(result[:style]).to eq :primary }
    it { expect(result[:onSuccess]).to eq :none }
    it { expect(result[:sfSymbolName]).to eq 'Login' }
    it { expect(result[:materialIconName]).to eq 'Login' }
  end
end
