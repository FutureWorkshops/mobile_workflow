module MobileWorkflow
  module Attachable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    def preview_url(attachment, options: { resize_to_fill: [200, 200] })
      return nil unless attachment.attached?

      if attachment.image?
        rails_representation_url(attachment.variant(options), host: heroku_attachment_host)
      elsif attachment.previewable?
        rails_representation_url(attachment.preview(options), host: heroku_attachment_host)
      else
        return nil
      end
    end

    def attachment_url(attachment)
      return nil unless attachment.attached?

      rails_blob_url(attachment, host: attachment_host)
    end

    private

    def attachment_host
      ENV.fetch('ATTACHMENTS_HOST', heroku_attachment_host)
    end

    def heroku_attachment_host
      # TODO: MBS - move this to a configuration property
      app_name = Rails.env.test? ? 'test-app' : ENV.fetch('HEROKU_APP_NAME')
      "https://#{app_name}.herokuapp.com"
    end
  end
end