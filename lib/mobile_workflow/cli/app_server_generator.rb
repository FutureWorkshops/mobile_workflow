# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

module MobileWorkflow
  module Cli
    class AppServerGenerator < Rails::Generators::AppGenerator
      hide!
      class_option :skip_test, type: :boolean, default: true, desc: 'Skip Test Unit'
      class_option :force, type: :boolean, default: true, desc: 'Force overwrite'
      class_option :skip_webpack_install, type: :boolean, default: true, desc: 'Skip webpacker installation'
      class_option :skip_bootsnap, type: :boolean, default: true, desc: 'Skip Bootsnap'

      class_option :version, type: :boolean, aliases: '-v', desc: 'Show version number and quit'
      class_option :help, type: :boolean, aliases: '-h', desc: 'Show this help message and quit'

      class_option :heroku, type: :boolean, default: false, desc: 'Create Heroku app'

      class_option :dokku, type: :boolean, default: false, desc: 'Create Dokku app'
      class_option :dokku_host, type: :string, desc: 'Specify the Dokku host machine e.g. 18.131.127.164'

      class_option :s3_storage, type: :boolean, default: false,
                                desc: 'Create an s3 backend for attachment upload and storage'
      class_option :aws_region, type: :string, default: 'us-east-1', desc: 'Specify a region to create AWS resources in'

      class_option :doorkeeper_oauth, type: :boolean, default: false, desc: 'Use Doorkeeper gem for OAuth login'

      def self.banner
        'mwf rails create:app_server <directory> <OpenAPI Spec file path> [options]'
      end

      def finish_template
        super
        after_bundle do
          build :procfiles
          build :rspec_generator
          build :factory_bot
          build :simplecov
          build :rollbar
          build :active_storage if options[:s3_storage]
          build :mobile_workflow_generator, ARGV[1]
          build :migrate_db
          build :administrate_generator
          build :format_source
          build :generate_dot_env
          build :rubocop
          build :git_commit
          build :heroku if options[:heroku]
          build :dokku, options[:dokku_host] if options[:dokku]
          build :s3_backend, options[:aws_region] if options[:s3_storage]
        end
      end

      protected

      def get_builder_class
        ::MobileWorkflow::Cli::AppBuilder
      end
    end
  end
end
