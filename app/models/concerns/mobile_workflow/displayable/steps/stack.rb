module MobileWorkflow
  module Displayable
    module Steps
      module Stack
        CONTENT_MODE_OPTIONS = [:scale_aspect_fill, :scale_aspect_fit] 

        def mw_display_text(text:, label: nil)
          {type: :text, label: label, text: text.to_s}.compact
        end
      
        def mw_display_image(attachment, content_mode: :scale_aspect_fill, options: { resize_to_fill: [1200, 600] })
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
            
        def mw_display_url_button(url:, label:, method: :put, style: :primary, confirm_title: nil, confirm_text: nil, on_success: :reload, sf_symbol_name: nil, material_icon_name: nil)
          validate_on_success!(on_success)
          validate_button_style!(style)
          
          {type: :button, label: label, url: url, method: method, style: style, confirmTitle: confirm_title, confirmText: confirm_text, onSuccess: on_success, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
        end
        alias_method :mw_display_button_for_url, :mw_display_url_button
        
        def mw_display_system_url_button(label:, apple_system_url: nil, android_deep_link: nil, style: :primary, sf_symbol_name: nil, material_icon_name: nil)
          validate_button_style!(style)
          raise 'Invalid android_deep_link' if android_deep_link && !android_deep_link.start_with?('http')
          
          {type: :button, label: label, appleSystemURL: apple_system_url, androidDeepLink: android_deep_link, style: style, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
        end
        alias_method :mw_display_button_for_system_url, :mw_display_system_url_button
        
        def mw_display_modal_workflow_button(label:, modal_workflow_name:, style: :primary, on_success: :none, sf_symbol_name: nil, material_icon_name: nil)
          validate_on_success!(on_success)
          validate_button_style!(style)
          
          {type: :button, label: label, modalWorkflow: modal_workflow_name, style: style, onSuccess: on_success, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name}.compact
        end
        alias_method :mw_display_button_for_modal_workflow, :mw_display_modal_workflow_button

        private
        def validate_content_mode!(on_success)
          raise 'Unknown content_mode' unless CONTENT_MODE_OPTIONS.include?(on_success)
        end

        def attachment_url(attachment)
          return nil unless attachment.attached?
        
          rails_blob_url(attachment, host: heroku_attachment_host)
        end
      end
    end
  end
end