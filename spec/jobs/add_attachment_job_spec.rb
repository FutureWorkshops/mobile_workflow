# frozen_string_literal: true

require 'rails_helper'

describe MobileWorkflow::AddAttachmentJob do
  let(:record) { double(object_class_name, id: 1) }
  let(:attribute_name) { 'image' }
  let(:object_class_name) { 'user' }
  let(:s3_client) { instance_double(Aws::S3::Resource) }
  let(:s3_bucket) { instance_double(Aws::S3::Bucket) }
  let(:active_storage_blob_class) { class_double('ActiveStorage::Blob').as_stubbed_const }
  let(:blob) { instance_double(ActiveStorage::Blob) }
  let(:s3_object) do
    instance_double(Aws::S3::Object, key: object_key, content_type: mimetype,
                                     size: content_length, etag: etag)
  end
  let(:binaries) { [{ identifier: 'image.jpg', mimetype: mimetype }] }
  let(:uuid) { '12798c4c-cd92-45fa-8635-e55cbc537266' }
  let(:mimetype) { 'image/jpeg' }
  let(:content_length) { 1234 }
  let(:etag) { '\"bedfcb39dd577200c58803afca94c7e7\"' }
  let(:object_key) { "#{object_class_name}/#{record.id}/#{attribute_name}/#{uuid}.jpeg" }

  before(:each) do
    stub_const('ENV', 'AWS_ACCESS_ID' => '1234567890', 'AWS_SECRET_KEY' => 'secret', 'AWS_REGION' => 'eu-west-1',
                      'AWS_BUCKET_NAME' => 'test')
    allow(Aws::S3::Resource).to receive(:new).with(region: 'eu-west-1', access_key_id: '1234567890',
                                                   secret_access_key: 'secret').and_return(s3_client)
    allow(s3_client).to receive(:bucket).with('test').and_return(s3_bucket)
    allow(s3_bucket).to receive(:object).with(object_key).and_return(s3_object)
    allow(active_storage_blob_class).to receive(:create!).with(key: object_key, filename: object_key,
                                                               byte_size: content_length, checksum: 'y+38s53VdyAMWIA6/KlMfnw=', content_type: mimetype).and_return(blob)
    allow(record).to receive("#{attribute_name}=").with(blob).and_return(blob)
    allow(record).to receive(:save).and_return(true)
  end

  it 'instantiates s3 client' do
    described_class.perform_now(record, object_key, attribute_name)
    expect(Aws::S3::Resource).to have_received(:new).with(region: 'eu-west-1', access_key_id: '1234567890',
                                                          secret_access_key: 'secret')
  end

  it 'instantiates s3 bucket' do
    described_class.perform_now(record, object_key, attribute_name)
    expect(s3_client).to have_received(:bucket).with('test')
  end

  it 'retrieves s3 object' do
    described_class.perform_now(record, object_key, attribute_name)
    expect(s3_bucket).to have_received(:object).with(object_key)
  end

  describe '#perform_now' do
    it 'creates an ActiveStorage::Blob' do
      expect(active_storage_blob_class).to receive(:create!).with(key: object_key, filename: object_key,
                                                                  byte_size: content_length, checksum: 'y+38s53VdyAMWIA6/KlMfnw=', content_type: mimetype)
      described_class.perform_now(record, object_key, attribute_name)
    end
  end
end
