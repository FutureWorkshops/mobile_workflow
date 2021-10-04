module MobileWorkflow
  module Displayable
    module Steps
      module Map
        def mw_map_item(id: self.id, text:, detail_text: nil, latitude:, longitude:)
          {id: id.to_s, text: text, detailText: detail_text, latitude: latitude, longitude: longitude}.compact
        end
      end
    end
  end
end