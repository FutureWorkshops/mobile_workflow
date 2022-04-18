# frozen_string_literal: true

require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module StyledContent
        module Stack
          extend MobileWorkflow::Deprecated
          include AppRail::Steps::StyledContent::Stack
          deprecated_alias :mw_stack_title, :ar_styled_content_stack_title
          deprecated_alias :mw_stack_text, :ar_styled_content_stack_text
          deprecated_alias :mw_stack_list_item, :ar_styled_content_stack_list_item
          deprecated_alias :mw_stack_button, :ar_styled_content_stack_button
        end
      end
    end
  end
end
