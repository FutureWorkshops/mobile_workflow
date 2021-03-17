class ApplicationRecord < ActiveRecord::Base
  include MobileWorkflow::Displayable
  
  self.abstract_class = true
end