desc "Add S3 storage to your environment"
task add_heroku_s3_storage: :environment do
  require 'mobile_workflow/cli'
  app_name = ENV['APP_NAME']
  aws = MobileWorkflow::Cli::AwsBackend.new(app_name: app_name)
  heroku = MobileWorkflow::Cli::HerokuBackend(app_name: app_name)
  aws.create
  aws.create_topic_subscription(heroku.notifications_endpoint)
end