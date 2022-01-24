module MobileWorkflow
  module Displayable
    module Steps
      module StyledContent
        module Stack
          def mw_stack_title(id:, title:)
            raise 'Missing id' if id.nil?
            raise 'Missing title' if title.nil?
        
            { id: id, title: title, type: :title }
          end
        
          def mw_stack_text(id:, text:)
            raise 'Missing id' if id.nil?
            raise 'Missing text' if text.nil?
        
            { id: id, text: text, type: :text }
          end
        
          def mw_stack_list_item(id:, text:, detail_text: nil, preview_url: nil)
            raise 'Missing id' if id.nil?
            raise 'Missing text' if text.nil?
        
            { id: id.to_s, text: text, detailText: detail_text, type: :listItem, imageURL: preview_url }.compact
          end
        
          def mw_stack_button(id:, label:, url: nil, method: :nil, on_success: :none, style: :primary, modal_workflow_name: nil, link_url: nil, sf_symbol_name: nil, apple_system_url: nil, android_deep_link: nil, confirm_title: nil, confirm_text: nil, share_text: nil, share_image_url: nil)
            raise 'Missing id' if id.nil?
            raise 'Missing label' if label.nil?
        
            validate_on_success!(on_success)
            validate_button_style!(style)
        
            { id: id, type: :button, label: label, url: url, method: method, onSuccess: on_success, style: style, modalWorkflow: modal_workflow_name, linkURL: link_url, sfSymbolName: sf_symbol_name, appleSystemURL: apple_system_url, androidDeepLink: android_deep_link, confirmTitle: confirm_title, confirmText: confirm_text, shareText: share_text, shareImageURL: share_image_url }.compact
          end
        end
      end
    end
  end
end