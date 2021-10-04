require 'rails_helper'

describe MobileWorkflow::Attachable do
  let(:test_class) { Class.new { include MobileWorkflow::Attachable } }

  subject { test_class.new }

  describe '#preview_url' do
    let(:result) { subject.preview_url(attachment, options: { resize_to_fill: [600, 1200] }) }
    let(:attachment) { double(ActiveStorage::Attached::One) }

    context 'ok' do
      before(:each) { allow(subject).to receive(:preview_url) { 'https://test.com/preview' } }

      it { expect(result).to eq 'https://test.com/preview' }
    end
  end

  describe '#attachment_url' do
    let(:result) { subject.attachment_url(attachment) }
    let(:attachment) { double(ActiveStorage::Attached::One) }

    context 'ok' do
      before(:each) { allow(subject).to receive(:attachment_url) { 'https://test.com/preview' } }

      it { expect(result).to eq 'https://test.com/preview' }
    end
  end
end
