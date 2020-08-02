module MobileWorkflow
  module Displayable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers
  
    def mw_list_item(id: self.id, text:, detail_text: nil, sf_symbol_name: nil, image_attachment: nil)
      mw_list_item = {id: id, text: text}
      mw_list_item[:detailText] = detail_text if detail_text
      mw_list_item[:sfSymbolName] = sf_symbol_name if sf_symbol_name
      mw_list_item[:imageURL] = preview_url(image_attachment, height: 100, width: 100) if image_attachment
      mw_list_item
    end
  
    def mw_display_text(label:, text:)
      {label: label, text: text.to_s, mimeType: 'text/plain'}
    end
  
    def mw_display_image(attachment)
      {previewURL: preview_url(attachment, height: 300, width: 600), url: attachment_url(attachment), mimeType: 'image/jpg'}
    end
  
    def mw_display_button(label:, url:, method: :put)
      {label: label, url: url, method: method, mimeType: 'application/url'}
    end
  
    def mw_display_delete_button(label: "Delete", url:)
      {label: label, url: url, method: :delete, mimeType: 'application/url'}
    end
  
    private
  
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