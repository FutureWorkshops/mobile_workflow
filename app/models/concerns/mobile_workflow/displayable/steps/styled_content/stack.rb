# frozen_string_literal: true

module MobileWorkflow
  module Displayable
    module Steps
      module StyledContent
        module Stack
          def mw_stack_title(title:)
            raise 'Missing title' if title.nil?

            { id: id, title: title, type: :title }
          end

          def mw_stack_text(text:)
            raise 'Missing text' if text.nil?

            { text: text, type: :text }
          end

          def mw_stack_list_item(text:, detail_text: nil, preview_url: nil)
            raise 'Missing text' if text.nil?

            { text: text, detailText: detail_text, type: :listItem, imageURL: preview_url }.compact
          end

          # Remove `modal_workflow_name` argument once V1 is no longer being used
          def mw_stack_button(label:, url: nil, method: :nil, on_success: :none, style: :primary, modal_workflow_name: nil, link_id: nil, link_url: nil, sf_symbol_name: nil, apple_system_url: nil, android_deep_link: nil, confirm_title: nil, confirm_text: nil, share_text: nil, share_image_url: nil)
            raise 'Missing label' if label.nil?

            validate_on_success!(on_success)
            validate_button_style!(style)

            { type: :button, label: label, url: url, method: method, onSuccess: on_success, style: style,
              modalWorkflow: modal_workflow_name, linkId: link_id, linkURL: link_url, sfSymbolName: sf_symbol_name, appleSystemURL: apple_system_url, androidDeepLink: android_deep_link, confirmTitle: confirm_title, confirmText: confirm_text, shareText: share_text, shareImageURL: share_image_url }.compact
          end
        end
      end
    end
  end
end
