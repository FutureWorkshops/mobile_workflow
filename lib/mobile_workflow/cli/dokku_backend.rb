# frozen_string_literal: true

module MobileWorkflow
  module Cli
    class DokkuBackend
      def initialize(dokku_host:, app_name:)
        @dokku_host = dokku_host
        @dokku_app_name = app_name.gsub('_', '-')
      end

      def create
        remote_command "dokku apps:create #{@dokku_app_name}"
        remote_command "dokku postgres:create #{@dokku_app_name}"
        remote_command "dokku postgres:link #{@dokku_app_name} #{@dokku_app_name}"
        remote_command "dokku domains:enable #{@dokku_app_name}"
        remote_command "dokku letsencrypt #{@dokku_app_name}"

        local_command "git remote add dokku dokku@#{@dokku_host}:#{@dokku_app_name}"
      end

      def configure_activestorage; end

      def deploy
        local_command 'git push dokku master'
      end

      def sync_dotenv
        env = File.read('.env').split.join(' ')
        puts "Setting env: #{env}"
        local_command "dokku config:set #{env}"
      end

      def destroy
        remote_command "dokku apps:destroy #{@dokku_app_name}"
      end

      def dokku_app_host
        remote_command "dokku url #{@dokku_app_name}"
      end

      def notifications_endpoint
        "https://#{dokku_app_host}/sns_notifications"
      end

      private

      def remote_command(command)
        command = "ssh -t ubuntu@#{@dokku_host} '#{command}'"
        local_command(command)
      end

      def local_command(command)
        puts "Running: #{command}"
        output = `#{command}`
        puts "Output: #{output}" unless output.blank?
        output
      end
    end
  end
end
