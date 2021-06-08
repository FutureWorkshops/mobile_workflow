desc "Add S3 storage to a Heroku app"
task add_heroku_s3_storage: :environment do
  require 'mobile_workflow/cli'
  app_name = ENV['APP_NAME']
  aws_region = ENV['AWS_REGION'] || 'us-east-1'
  aws = MobileWorkflow::Cli::AwsBackend.new(app_name: app_name, region: aws_region)
  heroku = MobileWorkflow::Cli::HerokuBackend.new(app_name: app_name)
  aws.create
  aws.create_topic_subscription(heroku.notifications_endpoint)
end