module MobileWorkflow
  module Displayable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers
    include Steps::Grid
    include Steps::List
    include Steps::Map
    include Steps::PieChart
    include Steps::Question
    include Steps::Stack
    
    private
    def preview_url(attachment, options:)
      return nil unless attachment.attached?

      if attachment.image?
        Rails.application.routes.url_helpers.rails_representation_url(attachment.variant(options), host: heroku_attachment_host)
      elsif attachment.previewable?
        Rails.application.routes.url_helpers.rails_representation_url(attachment.preview(options), host: heroku_attachment_host)
      else
        return nil
      end
    end

    def heroku_attachment_host
      # TODO: MBS - move this to a configuration property
      app_name = Rails.env.test? ? 'test-app' : ENV.fetch('HEROKU_APP_NAME')
      "https://#{app_name}.herokuapp.com"
    end
  end
end