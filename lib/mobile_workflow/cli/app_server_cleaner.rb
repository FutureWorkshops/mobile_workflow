# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module MobileWorkflow
  module Cli
    class AppServerCleaner < Thor
      class_option :version, type: :boolean, aliases: '-v', desc: 'Show version number and quit'
      class_option :help, type: :boolean, aliases: '-h', desc: 'Show this help message and quit'

      class_option :heroku, type: :boolean, default: false, desc: 'Clean Heroku app'
      class_option :s3_storage, type: :boolean, default: false,
                                desc: 'Clean an s3 backend for attachment upload and storage'
      class_option :aws_region, type: :string, default: 'us-east-1', desc: 'Specify a region to create AWS resources in'

      default_task :clean

      desc 'rails destroy:app_server APP_NAME', 'Destroy App server'
      def clean(app_name)
        `rm -rf #{app_name}`
        AwsBackend.new(app_name: app_name, region: options[:aws_region]).destroy! if options[:s3_storage]
        HerokuBackend.new(app_name: app_name).destroy! if options[:heroku]
      end
    end
  end
end
