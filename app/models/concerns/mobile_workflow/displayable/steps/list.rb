# frozen_string_literal: true

require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module List
        extend MobileWorkflow::Deprecated
        include AppRail::Steps::Core::List
        deprecated_alias :mw_list_item, :ar_core_list_item
        deprecated_alias :mw_list_search_suggestion, :ar_core_list_search_suggestion
      end
    end
  end
end
