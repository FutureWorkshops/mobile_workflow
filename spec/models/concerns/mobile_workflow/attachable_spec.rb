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

  context 'attachment_host' do
    context 'heroku' do
      before(:each) { stub_const('ENV', 'HEROKU_APP_NAME' => 'mobile-workflow') }

      context 'test environment' do
        it { expect(subject.send(:attachment_host)).to eq 'https://test-app.herokuapp.com' }
      end

      context 'development environment' do
        before(:each) { allow(Rails.env).to receive(:test?).and_return(false) }

        it { expect(subject.send(:attachment_host)).to eq 'https://mobile-workflow.herokuapp.com' }
      end
    end

    context 'custom' do
      before(:each) { stub_const('ENV', 'ATTACHMENTS_HOST' => 'http://attachments.com', 'HEROKU_APP_NAME' => 'mobile-workflow') }

      it { expect(subject.send(:attachment_host)).to eq 'http://attachments.com' }
    end

    context 'none' do
      it { expect(subject.send(:attachment_host)).to eq 'https://test-app.herokuapp.com' }
    end
  end
end
