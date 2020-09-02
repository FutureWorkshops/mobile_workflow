module MobileWorkflow
  module Displayable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers
    
    ON_SUCCESS_OPTIONS = [:none, :reload, :backward, :forward]
    BUTTON_STYLES = [:primary, :outline, :danger]
      
    def mw_list_item(id: self.id, text:, detail_text: nil, sf_symbol_name: nil, image_attachment: nil)
      mw_list_item = {id: id, text: text, detailText: detail_text, sfSymbolName: sf_symbol_name}
      mw_list_item[:imageURL] = preview_url(image_attachment, height: 100, width: 100) if image_attachment
      mw_list_item.compact   
    end
  
    def mw_display_text(text:, label: nil)
      {type: :text, label: label, text: text.to_s}.compact
    end
  
    def mw_display_image(attachment)
      {type: :image, previewURL: preview_url(attachment, height: 300, width: 600), url: attachment_url(attachment)}
    end
    
    def mw_display_video(attachment)
      {type: :video, previewURL: preview_url(attachment, height: 300, width: 600), url: attachment_url(attachment)}
    end
  
    def mw_display_button(label:, style: :primary, on_success: :forward)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, style: style, onSuccess: on_success}
    end
  
    def mw_display_delete_button(url:, label: "Delete", method: :delete, style: :danger, on_success: :backward)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, url: url, method: method, style: style, onSuccess: on_success}
    end
    
    def mw_display_button_for_url(label:, url:, method: :put, style: :primary, on_success: :reload)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, url: url, method: method, style: style, onSuccess: on_success}
    end
    
    def mw_display_button_for_modal_workflow(label:, modal_workflow:, style: :primary, on_success: :none)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, modalWorkflow: modal_workflow, style: style, onSuccess: on_success}
    end
  
    private
    def validate_on_success!(on_success)
      raise 'Unknown on_success action' unless ON_SUCCESS_OPTIONS.include?(on_success)
    end
    
    def validate_button_style!(style)
      raise 'Unknown style' unless BUTTON_STYLES.include?(style)      
    end
  
    def preview_url(attachment, height:, width:, options: { resize_to_fill: [height, width]} )
      return nil unless attachment.attached?

      if attachment.image?
        Rails.application.routes.url_helpers.rails_representation_url(attachment.variant(combine_options: options), host: attachment_host)
      elsif attachment.previewable?
        Rails.application.routes.url_helpers.rails_representation_url(attachment.preview(options), host: attachment_host)
      else
        return nil
      end
    end

    def attachment_url(attachment)
      return nil unless attachment.attached?
    
      Rails.application.routes.url_helpers.rails_blob_url(attachment, host: attachment_host)
    end

    def attachment_host
      "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
    end
  end
end