module MobileWorkflow
  module Displayable
    if defined?(Rails) && !Rails.env.test?
      extend ActiveSupport::Concern
      include Rails.application.routes.url_helpers
    end

    def self.included(base)
      base.extend(Steps::Form)
    end

    include Steps::List
    include Steps::Map
    include Steps::PieChart
    include Steps::Question
    include Steps::Stack
    include Steps::StyledContent::Grid
    include Steps::StyledContent::Stack

    BUTTON_STYLES = [:primary, :outline, :danger, :textOnly]
    ON_SUCCESS_OPTIONS = [:none, :reload, :backward, :forward]
    
    private
    def validate_on_success!(on_success)
      raise 'Unknown on_success action' unless ON_SUCCESS_OPTIONS.include?(on_success)
    end
    
    def validate_button_style!(style)
      raise 'Unknown style' unless BUTTON_STYLES.include?(style)      
    end

    def preview_url(attachment, options:)
      return nil unless attachment.attached? && defined?(Rails)

      if attachment.image?
        rails_representation_url(attachment.variant(options), host: heroku_attachment_host)
      elsif attachment.previewable?
        rails_representation_url(attachment.preview(options), host: heroku_attachment_host)
      else
        return nil
      end
    end

    def heroku_attachment_host
      # TODO: MBS - move this to a configuration property
      app_name = defined?(Rails) && Rails.env.test? ? 'test-app' : ENV.fetch('HEROKU_APP_NAME')
      "https://#{app_name}.herokuapp.com"
    end
  end
end