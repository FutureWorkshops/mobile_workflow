require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module List
        include AppRail::Steps::Core::List
        alias_method :mw_list_item, :ar_core_list_item
        alias_method :mw_list_search_suggestion, :ar_core_list_search_suggestion
      end
    end
  end
end