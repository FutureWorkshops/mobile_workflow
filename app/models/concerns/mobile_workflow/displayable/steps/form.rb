# frozen_string_literal: true


module MobileWorkflow
  module Displayable
    module Steps
      module Form
        def mw_form_section(label:, id:)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :section, id: id, label: label }
        end

        def mw_form_multiple_selection(label:, multiple_selection_options:, id:, selection_type: :single, optional: false, show_other_option: false)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?
          raise 'Missing multiple selection options' if multiple_selection_options.nil?

          { item_type: :multiple_selection, id: id, label: label,
            multiple_selection_options: multiple_selection_options, selection_type: selection_type, optional: optional, show_other_option: show_other_option }
        end

        def mw_form_multiple_selection_options(text:, hint: nil, is_pre_selected: false)
          raise 'Missing text' if text.nil?

          { text: text, hint: hint, isPreSelected: is_pre_selected }
        end

        def mw_form_number(label:, id:, placeholder: nil, optional: false, symbol_position: :leading, default_text_answer: nil, hint: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :number, number_type: :number, id: id, label: label,
            placeholder: placeholder, optional: optional, symbol_position: symbol_position, default_text_answer: default_text_answer, hint: hint }
        end

        def mw_form_text(label:, id:, placeholder: nil, optional: false, multiline: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :text, id: id, label: label, placeholder: placeholder,
            optional: optional, multiline: multiline, default_text_answer: default_text_answer }
        end

        def mw_form_date(label:, id:, optional: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :date, date_type: :calendar, id: id, label: label, optional: optional,
            default_text_answer: default_text_answer }
        end

        def mw_form_time(label:, id:, optional: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :time, id: id, label: label, optional: optional,
            default_text_answer: default_text_answer }
        end

        def mw_form_email(label:, id:, placeholder: nil, optional: false, default_text_answer: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :email, id: id, label: label, placeholder: placeholder,
            optional: optional, default_text_answer: default_text_answer }
        end

        def mw_form_password(label:, id:, placeholder: nil, optional: false, default_text_answer: nil, hint: nil)
          raise 'Missing label' if label.nil?
          raise 'Missing id' if id.nil?

          { item_type: :secure, id: id, label: label, placeholder: placeholder,
            optional: optional, default_text_answer: default_text_answer, hint: hint }
        end
      end
    end
  end
end
