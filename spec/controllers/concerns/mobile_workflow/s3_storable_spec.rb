require 'rails_helper'

describe MobileWorkflow::S3Storable do
  let(:test_class) { Struct.new(:id, :params) { include MobileWorkflow::S3Storable } }
  let(:id) { 1 }
  subject { test_class.new(id, params) }

  describe '#binary_urls' do
    let(:object) { double("Object", id: 1, class: double("ObjectClass", name: 'ObjectClass')) }
    let(:params) { {} }
    let(:uuid) { SecureRandom.uuid }
    let(:metadata) { nil }

    before(:each) do
      allow(subject).to receive(:s3_object_uuid) { uuid }
      allow(subject).to receive(:presigned_url).with("object_class/1/image/#{uuid}.jpg", metadata: metadata) { "https://aws.com/upload" }
    end

    context 'single binary' do
      let(:params) { { binaries: [{ identifier: 'image.jpg', mimetype: 'image/jpg' }]} }
      it { expect(subject.binary_urls(object).count).to eq 1 }
      it { expect(subject.binary_urls(object)[0][:identifier]).to eq "image.jpg" }
      it { expect(subject.binary_urls(object)[0][:url]).to eq "https://aws.com/upload" }
      it { expect(subject.binary_urls(object)[0][:method]).to eq "PUT" }
    end

    context 'with metadata' do
      let(:metadata) { { md5: 'fc7925ceff85b44276c576a72cd3f811' } }
      let(:params) { { binaries: [{ identifier: 'image.jpg', mimetype: 'image/jpg', metadata: metadata }] } }

      it { expect(subject.binary_urls(object).count).to eq 1 }
      it { expect(subject.binary_urls(object)[0][:identifier]).to eq "image.jpg" }
      it { expect(subject.binary_urls(object)[0][:url]).to eq "https://aws.com/upload" }
      it { expect(subject.binary_urls(object)[0][:method]).to eq "PUT" }
    end
  end
end