# frozen_string_literal: true

require 'aws-sdk-s3'

module MobileWorkflow
  module S3Storable
    if Object.const_defined?('Aws::S3')
      extend ActiveSupport::Concern

      def binary_urls(object)
        return unless params[:binaries]

        params[:binaries].map do |binary|
          identifier = binary[:identifier]
          key = binary[:key]
          extension = binary[:mimetype].split('/')[1] # i.e. image/jpg --> jpg, video/mp4 --> mp4
          metadata = binary[:metadata]

          {
            identifier: identifier,
            url: presigned_url(
              "#{object.class.name.underscore}/#{object.id}/#{key}/#{s3_object_uuid}.#{extension}", metadata: metadata
            ),
            method: 'PUT'
          }
        end
      end

      private

      def s3_object_uuid
        SecureRandom.uuid
      end

      def presigned_url(key, metadata: nil)
        presigner.presigned_url(:put_object, bucket: ENV['AWS_BUCKET_NAME'], key: key, metadata: metadata)
      end

      def presigner
        Aws::S3::Presigner.new(client: s3_client)
      end

      def s3_client
        Aws::S3::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'],
                            secret_access_key: ENV['AWS_SECRET_KEY'])
      end
    end
  end
end
