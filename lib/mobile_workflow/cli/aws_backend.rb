require 'json'

module MobileWorkflow::Cli
  class AwsBackend
  
    attr_accessor :access_id, :secret_key, :region, :bucket_name
  
    def initialize(app_name:, region:)
      @app_name = app_name
      @aws_name = @app_name.gsub("_", "-")
      @region = region
    end
  
    def bucket_name
      @aws_name
    end
  
    def create
      bucket_configuration = ''
      bucket_configuration += "--create-bucket-configuration LocationConstraint=#{@region}" unless @region.eql? 'us-east-1'
      aws_command "aws s3api create-bucket --bucket #{@aws_name} --acl private --region #{@region} #{bucket_configuration}"
      @topic_arn = aws_command("aws sns create-topic --name #{@aws_name} --region #{@region}")["TopicArn"]
      aws_command "aws iam create-user --user-name #{@aws_name}"
      aws_command "aws iam put-user-policy --user-name #{@aws_name} --policy-name s3 --policy-document '{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"s3:PutObject\",\"s3:PutObjectAcl\",\"s3:GetObject\", \"s3:DeleteObject\"],\"Resource\":[\"arn:aws:s3:::#{@aws_name}/*\"]}, {\"Effect\": \"Allow\", \"Action\": \"s3:ListBucket\", \"Resource\": \"arn:aws:s3:::#{@aws_name}\"}]}'"
      aws_command "aws iam put-user-policy --user-name #{@aws_name} --policy-name sns --policy-document '{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"sns:ConfirmSubscription\"],\"Resource\":[\"#{@topic_arn}\"]}]}'"
      aws_command "aws sns set-topic-attributes --topic-arn #{@topic_arn} --region #{@region} --attribute-name Policy --attribute-value '{\"Version\": \"2012-10-17\", \"Id\": \"s3\", \"Statement\": [{\"Sid\": \"#{@aws_name}-s3-sid\", \"Effect\": \"Allow\", \"Principal\": {\"AWS\": \"*\"}, \"Action\": \"SNS:Publish\", \"Resource\": \"#{@topic_arn}\", \"Condition\": {\"ArnEquals\": {\"aws:SourceArn\": \"arn:aws:s3:::#{@aws_name}\"}}}]}'"
      aws_command "aws s3api put-bucket-notification-configuration --bucket #{@aws_name} --notification-configuration '{\"TopicConfigurations\": [{\"TopicArn\": \"#{@topic_arn}\", \"Events\": [\"s3:ObjectCreated:*\"]}]}'"
      aws_credentials_json = aws_command("aws iam create-access-key --user-name #{@aws_name}")["AccessKey"]
      @access_id, @secret_key = aws_credentials_json["AccessKeyId"], aws_credentials_json["SecretAccessKey"]
      return @access_id, @secret_key
    end
  
    def put_env
      puts "AWS_ACCESS_ID=#{access_id}"
      puts "AWS_SECRET_KEY=#{secret_key}"
      puts "AWS_REGION=#{region}"
      puts "AWS_BUCKET_NAME=#{bucket_name}"
    end
  
    def write_env
      open('.env', 'a') { |f|
        f.puts "AWS_ACCESS_ID=#{access_id}"
        f.puts "AWS_SECRET_KEY=#{secret_key}"
        f.puts "AWS_REGION=#{region}"
        f.puts "AWS_BUCKET_NAME=#{bucket_name}"
      }
    end
  
    def create_topic_subscription(endpoint)
      aws_command "aws sns subscribe --topic-arn #{@topic_arn} --region #{@region} --protocol https --notification-endpoint #{endpoint}"
    end
  
    def destroy
      aws_command "aws s3api delete-bucket --bucket #{@aws_name} --region #{@region}"
    
      aws_command("aws sns list-topics")["Topics"].each do |topic|
        topic_arn = topic["TopicArn"]
        aws_command "aws sns delete-topic --topic-arn '#{topic_arn}'" if topic_arn.end_with?(@aws_name)
      end
    
      aws_command "aws iam delete-user-policy --user-name #{@aws_name} --policy-name s3"
      aws_command "aws iam delete-user-policy --user-name #{@aws_name} --policy-name sns"
      aws_command("aws iam list-access-keys --user-name #{@aws_name}")["AccessKeyMetadata"].each do |accessKeyMetadata|
        aws_command "aws iam delete-access-key --user-name #{@aws_name} --access-key #{accessKeyMetadata["AccessKeyId"]}"    
      end
      aws_command "aws iam delete-user --user-name #{@aws_name}"
    end
  
    private
    def aws_command(command)
      puts "Running: #{command}"
      output = `#{command}`
      return nil if output == nil || output.strip == ""
    
      puts "Output: #{output}"
      JSON.parse(output)
    end
  
  end
end