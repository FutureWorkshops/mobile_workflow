# frozen_string_literal: true

module MobileWorkflow
  class AddAttachmentJob < ApplicationJob
    def perform(object, object_key, attribute_name)
      object.send("#{attribute_name}=", active_record_blob)
      Rails.logger.warn "Error saving object: #{@object} #{object.errors.full_messages}" unless @object.save
    rescue NameError => e
      Rails.logger.warn "Error attaching object: #{e.message}"
    end

    private

    def active_record_blob
      s3_object = s3_bucket.object(object_key)
      checksum_base64 = checksum_base64(object_key, s3_object)
      ActiveStorage::Blob.create! key: s3_object.key, filename: s3_object.key, byte_size: s3_object.size, checksum: checksum_base64, content_type: s3_object.content_type
    end

    def checksum_base64(object_key, s3_object)
      path = Tempfile.new(object_key).path
      s3_object.download_file(path)
      file = File.new(path)
      Digest::MD5.file(file).base64digest
    end

    def s3_bucket
      Aws::S3::Resource.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY']).bucket(ENV['AWS_BUCKET_NAME'])
    end
  end
end
