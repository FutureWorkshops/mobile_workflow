module MobileWorkflow
  module S3Storable
    if Object.const_defined?("Aws::S3")
      extend ActiveSupport::Concern
      
      def binary_urls(object)
        return unless params["binaries"]
    
        params["binaries"].collect do |binary|
          extension = binary["mimetype"].split('/')[1] # i.e. image/jpg --> image, video/mp4 --> video
      
          {
            "identifier" => binary["identifier"],
            "url" => presigned_url("#{object.class.name.underscore}/#{object.id}/#{binary["identifier"]}.#{extension}"),
            "method" => "PUT"
          }
        end
      end
  
      private
      def presigned_url(key)
        presigner.presigned_url(:put_object, bucket: ENV['AWS_BUCKET_NAME'], key: key, metadata: {})
      end
  
      def presigner
        Aws::S3::Presigner.new(client: s3_client)
      end
  
      def s3_client
        Aws::S3::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY'])
      end
      
    end
  end
end