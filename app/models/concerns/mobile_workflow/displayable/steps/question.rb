module MobileWorkflow
  module Displayable
    module Steps
      module Question
        QUESTION_STYLES = [:single_choice, :multiple_choice]
        
        def mw_text_choice_question(question:, style:, text_choices:)
          raise 'Missing question' if question.blank?
          raise 'Text Choices should be a hash' unless text_choices.is_a?(Hash)
          validate_question_style!(style)
          
          text_choices_a = text_choices.map{|k, v| {_class: "ORKTextChoice", exclusive: false, text: k, value: v} }.to_a
          { question: question, answerFormat: { _class: "ORKTextChoiceAnswerFormat", style: style.to_s.camelize(:lower), textChoices: text_choices_a}}
        end

        private
        def validate_question_style!(style)
          raise 'Unknown style' unless QUESTION_STYLES.include?(style)      
        end
      end
    end
  end
end