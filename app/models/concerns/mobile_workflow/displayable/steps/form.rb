# frozen_string_literal: true
require 'app_rail/steps'

module MobileWorkflow
  module Displayable
    module Steps
      module Form
        extend MobileWorkflow::Deprecated
        include AppRail::Steps::CoreForms::Form
        deprecated_alias :mw_form_section, :ar_core_forms_form_section
        deprecated_alias :mw_form_multiple_selection, :ar_core_forms_form_multiple_selection
        deprecated_alias :mw_form_multiple_selection_options, :ar_core_forms_form_multiple_selection_options
        deprecated_alias :mw_form_number, :ar_core_forms_form_number
        deprecated_alias :mw_form_text, :ar_core_forms_form_text
        deprecated_alias :mw_form_date, :ar_core_forms_form_date
        deprecated_alias :mw_form_time, :ar_core_forms_form_time
        deprecated_alias :mw_form_email, :ar_core_forms_form_email
        deprecated_alias :mw_form_password, :ar_core_forms_form_password
      end
    end
  end
end
