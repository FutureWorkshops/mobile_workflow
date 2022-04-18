require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module Map
        extend MobileWorkflow::Deprecated
        include AppRail::Steps::Maps::Map
        deprecated_alias :mw_map_item, :ar_maps_map_item
      end
    end
  end
end