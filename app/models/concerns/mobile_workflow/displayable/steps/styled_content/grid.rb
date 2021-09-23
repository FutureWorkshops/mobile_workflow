module MobileWorkflow
  module Displayable
    module Steps
      module StyledContent
        module Grid
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
          
          def mw_grid_item(id: self.id, text:, image_attachment: nil, detail_text: nil, options: { resize_to_fill: [1560, 877.5] })
            raise 'Missing id' if id.nil?
            raise 'Missing text' if text.nil?
            
            item = { id: id, text: text, type: :item, detailText: detail_text }
            item[:imageURL] = preview_url(image_attachment, options: options) if image_attachment
            item
          end
        end
      end
    end
  end
end