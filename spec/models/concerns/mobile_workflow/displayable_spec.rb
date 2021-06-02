require 'rails_helper'

describe MobileWorkflow::Displayable do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }
  subject { test_class.new(id) }

  describe '#mw_list_item' do
    context 'text' do
      let(:result) { subject.mw_list_item(text: 'London') }
      
      it { expect(result[:id]).to eq 1 }
      it { expect(result[:text]).to eq 'London' }
    end
    
    context 'material icon' do
      let(:result) { subject.mw_list_item(text: 'London', material_icon_name: 'star') }
      
      it { expect(result[:id]).to eq 1 }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:materialIconName]).to eq 'star' }
    end
  end
  
  describe '#mw_list_search_suggestion' do
    context 'text' do
      let(:result) { subject.mw_list_search_suggestion(id: '1', text: 'London', section_name: 'City') }
      
      it { expect(result[:id]).to eq "1" }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:sectionName]).to eq 'City' }
    end
  end
  
  describe '#mw_map_item' do
    context 'text' do
      let(:result) { subject.mw_map_item(text: 'London', latitude: 20.1, longitude: 10.1) }
      it { expect(result[:id]).to eq "1" }
      it { expect(result[:text]).to eq 'London' }
      it { expect(result[:latitude]).to eq 20.1 }
      it { expect(result[:longitude]).to eq 10.1 }
    end
  end
  
  describe '#mw_pie_chart_item' do
    let(:result) { subject.mw_pie_chart_item(id: 1, label: 'Apples', value: 10) }
    it { expect(result[:id]).to eq 1 }
    it { expect(result[:label]).to eq 'Apples' }
    it { expect(result[:value]).to eq 10 }
  end
  
  describe '#mw_display_button' do
    context 'label, url' do
      let(:result) { subject.mw_display_button(label: 'Approve') }
      
      it { expect(result[:label]).to eq 'Approve' }
      it { expect(result[:onSuccess]).to eq :forward }
    end
  
  end
  
  describe '#mw_display_text' do
    context 'text' do
      let(:result) { subject.mw_display_text(label: 'City', text: 'London') }

      it { expect(result[:type]).to eq :text }      
      it { expect(result[:label]).to eq 'City' }      
      it { expect(result[:text]).to eq 'London' }
    end
  end
  
  describe '#mw_display_image' do
    context 'text' do
      let(:result) { subject.mw_display_image(label: 'City') }
      
      before(:each) do 
        allow(subject).to receive(:preview_url) { nil }
        allow(subject).to receive(:attachment_url) { nil }
      end

      it { expect(result[:type]).to eq :image }      
      it { expect(result[:contentMode]).to eq 'scaleAspectFill' }      
    end
  end

  describe '#mw_display_url_button' do
    
    context 'confirmTitle / confirmText' do
      let(:result) { subject.mw_display_url_button(label: 'Approve', url: 'https://example.com/1/approve', confirm_title: 'Approve?', confirm_text: 'Are you sure?') }
      
      it { expect(result[:label]).to eq 'Approve' }
      it { expect(result[:url]).to eq 'https://example.com/1/approve' }
      it { expect(result[:confirmTitle]).to eq 'Approve?' }
      it { expect(result[:confirmText]).to eq 'Are you sure?' }
    end
  
  end
  
  describe '#mw_display_system_url_button' do
    context 'apple only' do
      let(:result) { subject.mw_display_system_url_button(label: 'Call', apple_system_url: 'call://00447888888887', android_deep_link: 'https://maps.google.com') }

      it { expect(result[:type]).to eq :button }      
      it { expect(result[:appleSystemURL]).to eq 'call://00447888888887' }          
    end
    
    context 'maps' do
      let(:result) { subject.mw_display_button_for_system_url(label: 'Call', apple_system_url: 'https://maps.google.com', android_deep_link: 'https://maps.google.com') }

      it { expect(result[:type]).to eq :button }      
      it { expect(result[:appleSystemURL]).to eq 'https://maps.google.com' }   
      it { expect(result[:androidDeepLink]).to eq 'https://maps.google.com' }                 
    end
  end
  
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
  
  describe '#mw_grid_large_section' do
    let(:result) { subject.mw_grid_large_section(id: 0, text: 'Mountains') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }      
      it { expect(result[:text]).to eq 'Mountains' } 
      it { expect(result[:type]).to eq :largeSection } 
    end
  end
  
  describe '#mw_grid_small_section' do
    let(:result) { subject.mw_grid_small_section(id: 0, text: 'Mountains') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }      
      it { expect(result[:text]).to eq 'Mountains' } 
      it { expect(result[:type]).to eq :smallSection } 
    end
  end
  
  describe '#mw_grid_item' do
    let(:result) { subject.mw_grid_item(id: 0, text: 'Mountains') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }      
      it { expect(result[:text]).to eq 'Mountains' } 
      it { expect(result[:type]).to eq :item } 
    end
  end
end