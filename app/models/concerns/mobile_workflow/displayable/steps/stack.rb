require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module Stack
        extend MobileWorkflow::Deprecated
        include AppRail::Steps::Core::Stack
        deprecated_alias :mw_display_text, :ar_core_stack_text
        deprecated_alias :mw_display_image, :ar_core_stack_image        
        deprecated_alias :mw_display_unsplash_image, :ar_core_stack_unsplash_image        
        deprecated_alias :mw_display_video, :ar_core_stack_video               
        deprecated_alias :mw_display_button, :ar_core_stack_button             
        deprecated_alias :mw_display_delete_button, :ar_core_stack_delete_button                 
        deprecated_alias :mw_display_url_button, :ar_core_stack_url_button                   
        deprecated_alias :mw_display_button_for_url, :ar_core_stack_url_button
        deprecated_alias :mw_display_url_button, :ar_core_stack_url_button                   
        deprecated_alias :mw_display_system_url_button, :ar_core_stack_system_url_button                   
        deprecated_alias :mw_display_button_for_system_url, :ar_core_stack_system_url_button  
        deprecated_alias :mw_display_link_button, :ar_core_stack_link_button
        
        # Core V1
        deprecated_alias :mw_display_modal_workflow_button, :ar_core_stack_modal_workflow_button
        deprecated_alias :mw_display_button_for_modal_workflow, :ar_core_stack_modal_workflow_button
      end
    end
  end
end