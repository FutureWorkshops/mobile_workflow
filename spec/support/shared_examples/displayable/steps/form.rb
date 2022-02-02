# frozen_string_literal: true

shared_examples_for 'form' do
  describe '#mw_form_section' do
    let(:result) { test_class.mw_form_section(label: 'Personal Information', id: 1) }

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :section }
    it { expect(result[:label]).to eq 'Personal Information' }
  end

  describe '#mw_form_multiple_selection' do
    let(:multiple_section_options) do
      [{ text: 'Alcohol Free', isPreSelected: true }, { text: 'Sunrise Yoga', isPreSelected: false }]
    end
    let(:result) do
      test_class.mw_form_multiple_selection(label: 'Challenge Type', id: 1,
                                            multiple_selection_options: multiple_section_options, selection_type: :single, optional: false)
    end

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :multiple_selection }
    it { expect(result[:label]).to eq 'Challenge Type' }
    it { expect(result[:multiple_selection_options]).to eq multiple_section_options }
    it { expect(result[:selection_type]).to eq :single }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:show_other_option]).to eq false }
  end

  describe '#mw_form_multiple_selection_options' do
    let(:result) do
      test_class.mw_form_multiple_selection_options(text: 'Open for all', hint: 'Every user will be able to join',
                                                    is_pre_selected: false)
    end

    it { expect(result[:text]).to eq 'Open for all' }
    it { expect(result[:hint]).to eq 'Every user will be able to join' }
    it { expect(result[:isPreSelected]).to eq false }
  end

  describe '#mw_form_number' do
    let(:result) do
      test_class.mw_form_number(label: 'Target Amount', id: 1, placeholder: '100 Eur', default_text_answer: 50)
    end

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :number }
    it { expect(result[:number_type]).to eq :number }
    it { expect(result[:label]).to eq 'Target Amount' }
    it { expect(result[:placeholder]).to eq '100 Eur' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:default_text_answer]).to eq 50 }
  end

  describe '#mw_form_text' do
    let(:result) { test_class.mw_form_text(label: 'Your Location', id: 1, placeholder: 'London') }

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :text }
    it { expect(result[:label]).to eq 'Your Location' }
    it { expect(result[:placeholder]).to eq 'London' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:multiline]).to eq false }
  end

  describe '#mw_form_date' do
    let(:result) { test_class.mw_form_date(label: 'Start Date', id: 1, optional: true) }

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :date }
    it { expect(result[:date_type]).to eq :calendar }
    it { expect(result[:label]).to eq 'Start Date' }
    it { expect(result[:optional]).to eq true }
  end

  describe '#mw_form_time' do
    let(:result) { test_class.mw_form_time(label: 'Start Time', id: 1, optional: true) }
    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :time }
    it { expect(result[:label]).to eq 'Start Time' }
    it { expect(result[:optional]).to eq true }
  end

  describe '#mw_form_email' do
    let(:result) do
      test_class.mw_form_email(label: 'Your Email', id: 1, placeholder: 'example@email.com',
                               default_text_answer: 'montse@futureworkshops.com')
    end

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :email }
    it { expect(result[:label]).to eq 'Your Email' }
    it { expect(result[:placeholder]).to eq 'example@email.com' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:default_text_answer]).to eq 'montse@futureworkshops.com' }
  end

  describe '#mw_form_password' do
    let(:result) do
      test_class.mw_form_password(label: 'Your Password', id: 1, placeholder: 'Secret123',
                                  hint: 'Must be at least 8 characters long')
    end

    it { expect(result[:id]).to eq 1 }
    it { expect(result[:item_type]).to eq :secure }
    it { expect(result[:label]).to eq 'Your Password' }
    it { expect(result[:placeholder]).to eq 'Secret123' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:hint]).to eq 'Must be at least 8 characters long' }
  end
end
