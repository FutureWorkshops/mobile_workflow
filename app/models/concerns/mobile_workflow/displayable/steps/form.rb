module MobileWorkflow
  module Displayable
    module Steps
      module Form
        def mw_form_section(label:, identifier:)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :section, label: label, identifier: identifier }
        end
    
        def mw_form_multiple_selection(label:, identifier:, multiple_selection_options:, selection_type: :single, optional: false, show_other_option: false)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
          raise 'Missing multiple selection options' if multiple_selection_options.nil?
    
          { item_type: :multiple_selection, label: label, identifier: identifier, multiple_selection_options: multiple_selection_options, selection_type: selection_type, optional: optional, show_other_option: show_other_option }
        end
    
        def mw_form_multiple_selection_options(text:, hint: nil, is_pre_selected: false)
          raise 'Missing text' if text.nil?
    
          { text: text, hint: hint, isPreSelected: is_pre_selected }
        end
    
        def mw_form_number(label:, identifier:, placeholder: nil, optional: false, symbol_position: :leading, default_text_answer: nil, hint: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :number, number_type: :number, label: label, identifier: identifier, placeholder: placeholder, optional: optional, symbol_position: symbol_position, default_text_answer: default_text_answer, hint: hint }
        end
    
        def mw_form_text(label:, identifier:, placeholder: nil, optional: false, multiline: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :text, label: label, identifier: identifier, placeholder: placeholder, optional: optional, multiline: multiline, default_text_answer: default_text_answer }
        end
    
        def mw_form_date(label:, identifier:, optional: false, default_date_time_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :date, date_type: :calendar, label: label, identifier: identifier, optional: optional, default_date_time_answer: default_date_time_answer }
        end
    
        def mw_form_time(label:, identifier:, optional: false, default_date_time_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :time, label: label, identifier: identifier, optional: optional, default_date_time_answer: default_date_time_answer }
        end
    
        def mw_form_email(label:, identifier:, placeholder: nil, optional: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :email, label: label, identifier: identifier, placeholder: placeholder, optional: optional, default_text_answer: default_text_answer }
        end
    
        def mw_form_password(label:, identifier:, placeholder: nil, optional: false, default_text_answer: nil, hint: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing identifier' if identifier.nil?
    
          { item_type: :secure, label: label, identifier: identifier, placeholder: placeholder, optional: optional, default_text_answer: default_text_answer, hint: hint }
        end
      end
    end
  end
end