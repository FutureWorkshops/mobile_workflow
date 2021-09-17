# frozen_string_literal: true

module MobileWorkflow
  class AddAttachmentJob < ApplicationJob
    def perform(object, object_key, attribute_name)
      object.send("#{attribute_name}=", active_record_blob_from_s3(object_key))
      Rails.logger.warn "Error saving object: #{object} #{object.errors.full_messages}" unless object.save
    rescue NoMethodError => e
      Rails.logger.warn "Error attaching object: #{e.message}"
    end

    private

    def active_record_blob_from_s3(object_key)
      # etag cannot be used as the MD5 checksum when doing multi-part uploads
      s3_object = s3_bucket.object(object_key)
      ActiveStorage::Blob.create! key: s3_object.key, filename: s3_object.key, byte_size: s3_object.size,
                                  checksum: s3_object.etag.delete('"'), content_type: s3_object.content_type
    end

    def s3_bucket
      Aws::S3::Resource.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY']).bucket(ENV['AWS_BUCKET_NAME'])
    end
  end
end
