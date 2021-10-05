shared_examples_for 'question' do
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
