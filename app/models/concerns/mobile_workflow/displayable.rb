module MobileWorkflow
  module Displayable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers
    
    ON_SUCCESS_OPTIONS = [:none, :reload, :backward, :forward]
    BUTTON_STYLES = [:primary, :outline, :danger]  
    CONTENT_MODE_OPTIONS = [:scale_aspect_fill, :scale_aspect_fit] 
    QUESTION_STYLES = [:single_choice, :multiple_choice] 
    
    def mw_list_item(id: self.id, text:, detail_text: nil, sf_symbol_name: nil, image_attachment: nil)
      mw_list_item = {id: id, text: text, detailText: detail_text, sfSymbolName: sf_symbol_name}
      mw_list_item[:imageURL] = preview_url(image_attachment, options: { resize_to_fill: [100, 100] }) if image_attachment
      mw_list_item.compact
    end
    
    def mw_list_search_suggestion(id:, text:, section_name:, sf_symbol_name: nil)
      {id: id, text: text, sectionName: section_name, sfSymbolName: sf_symbol_name}.compact
    end
    
    def mw_map_item(id: self.id, text:, detail_text: nil, latitude:, longitude:)
      {id: id.to_s, text: text, detailText: detail_text, latitude: latitude, longitude: longitude}.compact
    end
    
    def mw_pie_chart_item(id: self.id, label:, value:)
      {id: id, label: label, value: value}.compact
    end
  
    def mw_display_text(text:, label: nil)
      {type: :text, label: label, text: text.to_s}.compact
    end
  
    def mw_display_image(attachment, content_mode: :scale_aspect_fill, options: { resize_to_fill: [600, 1200] })
      validate_content_mode!(content_mode)
      
      {type: :image, contentMode: content_mode.to_s.camelize(:lower), previewURL: preview_url(attachment, options: options), url: attachment_url(attachment)}
    end
    
    def mw_display_unsplash_image(image_url)
      if image_url.start_with? "https://unsplash.com/photos"
        unsplash_id = image_url.split('/').last
        image_url = "https://source.unsplash.com/#{unsplash_id}/800x600"
      end
      
      {type: :image, previewURL: image_url, url: image_url}.compact
    end
    
    def mw_display_video(attachment, preview_options: { resize_to_fill: [600, 1200] })
      {type: :video, previewURL: preview_url(attachment, options: preview_options), url: attachment_url(attachment)}
    end
  
    def mw_display_button(label:, style: :primary, on_success: :forward, sf_symbol_name: nil, material_icon_name: nil)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, style: style, onSuccess: on_success, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
    end
  
    def mw_display_delete_button(url:, label: "Delete", method: :delete, style: :danger, on_success: :backward)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, url: url, method: method, style: style, onSuccess: on_success, sfSymbolName: 'trash', materialIconName: 'delete'}.compact
    end
        
    def mw_display_url_button(label:, url:, method: :put, style: :primary, confirm_title: nil, confirm_text: nil, on_success: :reload, sf_symbol_name: nil, material_icon_name: nil)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, url: url, method: method, style: style, confirmTitle: confirm_title, confirmText: confirm_text, onSuccess: on_success, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
    end
    alias_method :mw_display_button_for_url, :mw_display_url_button
    
    def mw_display_system_url_button(label:, apple_system_url: nil, android_deep_link: nil, style: :primary, sf_symbol_name: nil, material_icon_name: nil)
      validate_button_style!(style)
      raise 'Invalid android_deep_link' unless android_deep_link.start_with?('http')
      
      {type: :button, label: label, appleSystemURL: apple_system_url, androidDeepLink: android_deep_link, style: style, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
    end
    alias_method :mw_display_button_for_system_url, :mw_display_system_url_button
    
    def mw_display_modal_workflow_button(label:, modal_workflow_name:, style: :primary, on_success: :none, sf_symbol_name: nil, material_icon_name: nil)
      validate_on_success!(on_success)
      validate_button_style!(style)
      
      {type: :button, label: label, modalWorkflow: modal_workflow_name, style: style, onSuccess: on_success, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
    end
    alias_method :mw_display_button_for_modal_workflow, :mw_display_modal_workflow_button
    
    def mw_text_choice_question(question:, style:, text_choices:)
      raise 'Missing question' if question.blank?
      raise 'Text Choices should be a hash' unless text_choices.is_a?(Hash)
      validate_question_style!(style)
      
      text_choices_a = text_choices.map{|k, v| {_class: "ORKTextChoice", exclusive: false, text: k, value: v} }.to_a
      { question: question, answerFormat: { _class: "ORKTextChoiceAnswerFormat", style: style.to_s.camelize(:lower), textChoices: text_choices_a}}
    end
    
    def mw_grid_large_section(id:, text:)
      raise 'Missing id' if id.nil?
      raise 'Missing text' if text.nil?
      
      { id: id, text: text, type: :largeSection }
    end
    
    def mw_grid_small_section(id:, text:)
      raise 'Missing id' if id.nil?
      raise 'Missing text' if text.nil?
      
      { id: id, text: text, type: :smallSection }
    end
    
    def mw_grid_item(id: self.id, text:, image_attachment: nil)
      raise 'Missing id' if id.nil?
      raise 'Missing text' if text.nil?
      
      item = { id: id, text: text, type: :item }
      item[:imageURL] = preview_url(image_attachment, options: { resize_to_fill: [1224, 760] }) if image_attachment
      item
    end
  
    private
    def validate_on_success!(on_success)
      raise 'Unknown on_success action' unless ON_SUCCESS_OPTIONS.include?(on_success)
    end
    
    def validate_content_mode!(on_success)
      raise 'Unknown content_mode' unless CONTENT_MODE_OPTIONS.include?(on_success)
    end
    
    def validate_button_style!(style)
      raise 'Unknown style' unless BUTTON_STYLES.include?(style)      
    end
    
    def validate_question_style!(style)
      raise 'Unknown style' unless QUESTION_STYLES.include?(style)      
    end
    
    def preview_url(attachment, options:)
      return nil unless attachment.attached?

      if attachment.image?
        Rails.application.routes.url_helpers.rails_representation_url(attachment.variant(options), host: attachment_host)
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