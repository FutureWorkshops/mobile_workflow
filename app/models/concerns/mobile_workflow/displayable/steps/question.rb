# frozen_string_literal: true

module MobileWorkflow
  module Displayable
    module Steps
      module Question
        QUESTION_STYLES = %i[single_choice multiple_choice].freeze

        def mw_text_choice_question(question:, style:, text_choices:)
          raise 'Missing question' if question.empty?
          raise 'Text Choices should be a hash' unless text_choices.is_a?(Hash)

          validate_question_style!(style)

          text_choices_a = text_choices.map do |k, v|
            { _class: 'ORKTextChoice', exclusive: false, text: k, value: v }
          end.to_a
          { question: question,
            answerFormat: { _class: 'ORKTextChoiceAnswerFormat', style: camelcase_converter(style.to_s, first_letter: :lower),
                            textChoices: text_choices_a } }
        end

        private

        def validate_question_style!(style)
          raise 'Unknown style' unless QUESTION_STYLES.include?(style)
        end
      end
    end
  end
end
