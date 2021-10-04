require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::Form do
  let(:subject) { Class.new { include MobileWorkflow::Displayable } }

  describe '#mw_form_section' do
    let(:result) { subject.mw_form_section(label: 'Personal Information', identifier: 'info') }

    it { expect(result[:item_type]).to eq :section }
    it { expect(result[:label]).to eq 'Personal Information' }
    it { expect(result[:identifier]).to eq 'info' }
  end

  describe '#mw_form_multiple_selection' do
    let(:multiple_section_options) { [ { text: 'Alcohol Free', isPreSelected: true }, { text: 'Sunrise Yoga', isPreSelected: false } ] }
    let(:result) { subject.mw_form_multiple_selection(label: 'Challenge Type', identifier: 'challenge_type', multiple_selection_options: multiple_section_options, selection_type: :single, optional: false) }

    it { expect(result[:item_type]).to eq :multiple_selection }
    it { expect(result[:label]).to eq 'Challenge Type' }
    it { expect(result[:identifier]).to eq 'challenge_type' }
    it { expect(result[:multiple_selection_options]).to eq multiple_section_options }
    it { expect(result[:selection_type]).to eq :single }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:show_other_option]).to eq false }
  end

  describe '#mw_form_multiple_selection_options' do
    let(:result) { subject.mw_form_multiple_selection_options(text: 'Open for all', hint: 'Every user will be able to join', is_pre_selected: false) }

    it { expect(result[:text]).to eq 'Open for all' }
    it { expect(result[:hint]).to eq 'Every user will be able to join' }
    it { expect(result[:isPreSelected]).to eq false }
  end

  describe '#mw_form_number' do
    let(:result) { subject.mw_form_number(label: 'Target Amount', identifier: 'target_amount', placeholder: '100 Eur', default_text_answer: 50) }

    it { expect(result[:item_type]).to eq :number }
    it { expect(result[:number_type]).to eq :number }
    it { expect(result[:label]).to eq 'Target Amount' }
    it { expect(result[:identifier]).to eq 'target_amount' }
    it { expect(result[:placeholder]).to eq '100 Eur' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:default_text_answer]).to eq 50 }
  end

  describe '#mw_form_text' do
    let(:result) { subject.mw_form_text(label: 'Your Location', identifier: 'location', placeholder: 'London') }

    it { expect(result[:item_type]).to eq :text }
    it { expect(result[:label]).to eq 'Your Location' }
    it { expect(result[:identifier]).to eq 'location' }
    it { expect(result[:placeholder]).to eq 'London' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:multiline]).to eq false }
  end

  describe '#mw_form_date' do
    let(:result) { subject.mw_form_date(label: 'Start Date', identifier: 'start_date', optional: true) }

    it { expect(result[:item_type]).to eq :date }
    it { expect(result[:date_type]).to eq :calendar }
    it { expect(result[:label]).to eq 'Start Date' }
    it { expect(result[:identifier]).to eq 'start_date' }
    it { expect(result[:optional]).to eq true }
  end

  describe '#mw_form_time' do
    let(:result) { subject.mw_form_time(label: 'Start Time', identifier: 'start_time', optional: true) }

    it { expect(result[:item_type]).to eq :time }
    it { expect(result[:label]).to eq 'Start Time' }
    it { expect(result[:identifier]).to eq 'start_time' }
    it { expect(result[:optional]).to eq true }
  end

  describe '#mw_form_email' do
    let(:result) { subject.mw_form_email(label: 'Your Email', identifier: 'email', placeholder: 'example@email.com', default_text_answer: 'montse@futureworkshops.com') }

    it { expect(result[:item_type]).to eq :email }
    it { expect(result[:label]).to eq 'Your Email' }
    it { expect(result[:identifier]).to eq 'email' }
    it { expect(result[:placeholder]).to eq 'example@email.com' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:default_text_answer]).to eq 'montse@futureworkshops.com' }
  end

  describe '#mw_form_password' do
    let(:result) { subject.mw_form_password(label: 'Your Password', identifier: 'password', placeholder: 'Secret123', hint: 'Must be at least 8 characters long') }

    it { expect(result[:item_type]).to eq :secure }
    it { expect(result[:label]).to eq 'Your Password' }
    it { expect(result[:identifier]).to eq 'password' }
    it { expect(result[:placeholder]).to eq 'Secret123' }
    it { expect(result[:optional]).to eq false }
    it { expect(result[:hint]).to eq 'Must be at least 8 characters long' }
  end
end
