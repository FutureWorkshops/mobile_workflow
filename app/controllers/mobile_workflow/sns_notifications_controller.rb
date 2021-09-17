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
          AddAttachmentJob.perform_now(object, object_key, attribute_name)
          head :ok
        end
      rescue NameError => e
        Rails.logger.warn "Error attaching object: #{e.message}"
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
 
      private
       
      def verify_request_authenticity
        head :unauthorized if raw_post.blank?
    
        #head :unauthorized if raw_post.blank? || !message_verifier.authentic?(raw_post) # Not working
      end
  
      def object
        @object ||= begin
          object_class_name, object_id = key_identifiers
          object_class_name.camelcase.constantize.find(object_id.to_i)
        end
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

      def sns_client
        Aws::SNS::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_ID'], secret_access_key: ENV['AWS_SECRET_KEY'])
      end
    end
  end  
end
