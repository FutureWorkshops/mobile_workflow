# 0.10.0

### Breaking changes
* Remove `id` argument from all `MobileWorkflow::Displayable::Steps::StyledContent::Stack` methods

# 0.7.7
The following utility methods have changed their parameters:

```ruby
# app/models/concerns/mobile_workflow/displayable/steps/styled_content/grid.rb#20
def mw_grid_item(id: self.id, text:, detail_text: nil, preview_url: nil)
  raise 'Missing id' if id.nil?
  raise 'Missing text' if text.nil?
  
  { id: id, text: text, type: :item, detailText: detail_text, imageURL: preview_url }.compact
end

# app/models/concerns/mobile_workflow/displayable/steps/styled_content/stack.rb#20
def mw_stack_list_item(id:, text:, detail_text: nil, preview_url: nil)
  raise 'Missing id' if id.nil?
  raise 'Missing text' if text.nil?

  { id: id.to_s, text: text, detailText: detail_text, type: :listItem, imageURL: preview_url }.compact
end

# app/models/concerns/mobile_workflow/displayable/steps/list.rb#5
def mw_list_item(id: self.id, text:, detail_text: nil, sf_symbol_name: nil, material_icon_name: nil, preview_url: nil)
  { id: id, text: text, detailText: detail_text, sfSymbolName: sf_symbol_name, materialIconName: material_icon_name, imageURL: preview_url }.compact
end

# app/models/concerns/mobile_workflow/displayable/steps/stack.rb#26
def mw_display_video(preview_url:, attachment_url:)
  {type: :video, previewURL: preview_url, url: attachment_url}
end

# app/models/concerns/mobile_workflow/displayable/steps/stack.rb#11
def mw_display_image(preview_url:, attachment_url:, content_mode: :scale_aspect_fill)
  validate_content_mode!(content_mode)
  
  {type: :image, contentMode: camelcase_converter(content_mode.to_s, first_letter: :lower), previewURL: preview_url, url: attachment_url}
end
```

All URLs MUST now be explicitly sent as arguments to the above methods, which means they must be previously set. If not, the methods will not work.

In order to support projects using `ActiveStorage`, there is a new model concern `MobileWorkflow::Attachable` that provides a few helpers. This is what you can do to upgrade if you use ActiveStorage (otherwise the helpers must be manually created):

1. Include the concern in the `ApplicationRecord` class, together with `MobileWorkflow::Displayable`:

```ruby
class ApplicationRecord < ActiveRecord::Base
  include MobileWorkflow::Attachable
  include MobileWorkflow::Displayable
end
```

2. Once included, the following helpers will be available, so use them to generate the intended URLs:

```ruby
def preview_url(attachment, options: { resize_to_fill: [200, 200] })
  return nil unless attachment.attached?

  if attachment.image?
    rails_representation_url(attachment.variant(options), host: heroku_attachment_host)
  elsif attachment.previewable?
    rails_representation_url(attachment.preview(options), host: heroku_attachment_host)
  else
    return nil
  end
end

def attachment_url(attachment)
  return nil unless attachment.attached?

  rails_blob_url(attachment, host: heroku_attachment_host)
end
```

Example of use:
```ruby
# Old method call
mw_list_item(text: 'John Doe', detail_text: 'Company Name', image_attachment: <ActiveStorage::Attached::One>, image_url: 'https://test.org/preview')

# New method call
preview_url = preview_url(<ActiveStorage::Attached::One>, options: { resize_to_fill: [200, 200] }) || 'https://test.org/preview'
mw_list_item(text: 'John Doe', detail_text: 'Company Name', preview_url: preview_url)
```
