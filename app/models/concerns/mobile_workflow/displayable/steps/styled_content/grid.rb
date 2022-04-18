# frozen_string_literal: true

require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module StyledContent
        module Grid
          extend MobileWorkflow::Deprecated
          include AppRail::Steps::StyledContent::Grid
          deprecated_alias :mw_grid_large_section, :ar_styled_content_grid_large_section
          deprecated_alias :mw_grid_small_section, :ar_styled_content_grid_small_section
          deprecated_alias :mw_grid_item, :ar_styled_content_grid_item
        end
      end
    end
  end
end
