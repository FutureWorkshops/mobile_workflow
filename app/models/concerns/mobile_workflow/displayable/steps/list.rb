module MobileWorkflow
  module Displayable
    module Steps
      module List
        def mw_list_item(text:, id: self.id, detail_text: nil, sf_symbol_name: nil, material_icon_name: nil, image_attachment: nil, image_url: nil)
          mw_list_item = { id: id, text: text, detailText: detail_text, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name }
          mw_list_item[:imageURL] = image_attachment&.attached? ? preview_url(image_attachment, options: { resize_to_fill: [200, 200] }) : image_url
          mw_list_item.compact
        end
        
        def mw_list_search_suggestion(id: self.id, text:, section_name:, sf_symbol_name: nil)
          {id: id.to_s, text: text, sectionName: section_name, sfSymbolName: sf_symbol_name}.compact
        end
      end
    end
  end
end