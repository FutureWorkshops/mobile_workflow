module MobileWorkflow
  class SnsNotificationsController < ActionController::API
    if Object.const_defined?("Aws::S3") && Object.const_defined?("Aws::SNS")
      before_action :verify_request_authenticity
 
      def create
        Rails.logger.info("Message body: #{message_body}")
    
        case message_body['Type']
        when 'SubscriptionConfirmation'
          confirm_subscription ? (head :ok) : (head :bad_request)
        else
          add_attachment
        end
      end
 
      private
      def add_attachment
        begin
          @object = find_object
          @object.send("#{attribute_name}=",active_record_blob)
          if @object.save
            head :ok
          else
            Rails.logger.warn "Error saving object: #{@object} #{object.errors.full_messages}"
            head :unprocessable_entity
          end
        rescue NameError => e
          Rails.logger.warn "Error attaching object: #{e.message}"
          head :unprocessable_entity
        end
      end
       
      def verify_request_authenticity
        head :unauthorized if raw_post.blank?
    
        #head :unauthorized if raw_post.blank? || !message_verifier.authentic?(raw_post) # Not working
      end
  
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
  
      def find_object
        object_class_name, object_id = key_identifiers
        object_class_name.camelcase.constantize.find(object_id.to_i)
      end
  
      def attribute_name
        key_identifiers[2]
      end
  
      def key_identifiers
        object_class_name, object_id, attribute_name = object_key.split("/")
        return object_class_name, object_id, attribute_name
      end
      
      def object_key
        message = JSON.parse(message_body['Message'])
        message['Records'][0]['s3']['object']['key']        
      end
 
      def message_body
        @message_body ||= JSON.parse(raw_post)
      end
  
      def raw_post
        @raw_post ||= request.raw_post
      end
 
      def message_verifier
        @message_verifier ||= Aws::SNS::MessageVerifier.new
      end
 
      def confirm_subscription
        sns_client.confirm_subscription(
          topic_arn: message_body['TopicArn'],
          token: message_body['Token']
        )
        return true
      rescue Aws::SNS::Errors::ServiceError => e
        Rails.logger.warn(e.message)
        return false
      end
  
      def s3_bucket
        Aws::S3::Resource.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY']).bucket(ENV['AWS_BUCKET_NAME'])
      end
  
      def sns_client
        Aws::SNS::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY'])
      end
    end
  end  
end
