require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::Question do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_text_choice_question' do
    let(:result) { subject.mw_text_choice_question(question: question, style: style, text_choices: text_choices) }

    context 'ok' do
      let(:question) { 'Expense type?' }
      let(:style) { :single_choice }
      let(:text_choices) { {"Business" => 0, "Personal" => 1} }

      it { expect(result[:question]).to eq 'Expense type?' }      
      it { expect(result[:answerFormat][:style]).to eq 'singleChoice' } 
      it { expect(result[:answerFormat][:textChoices].count).to eq 2 }      
    end
  end
end
