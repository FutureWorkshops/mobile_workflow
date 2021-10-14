class ApplicationRecord < ActiveRecord::Base
  include MobileWorkflow::Attachable
  include MobileWorkflow::Displayable

  self.abstract_class = true
end
