require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::StyledContent::Stack do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_grid_large_section' do
    let(:result) { subject.mw_stack_title(id: 0, title: 'Challenges') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }
      it { expect(result[:title]).to eq 'Challenges' }
      it { expect(result[:type]).to eq :title }
    end
  end

  describe '#mw_stack_text' do
    let(:result) { subject.mw_stack_text(id: 0, text: 'These are the challenges') }

    context 'ok' do
      it { expect(result[:id]).to eq 0 }
      it { expect(result[:text]).to eq 'These are the challenges' }
      it { expect(result[:type]).to eq :text }
    end
  end

  describe '#mw_stack_list_item' do
    context 'image attachment' do
      let(:result) { subject.mw_stack_list_item(id: 0, text: 'John Doe', detail_text: 'Participant', attachment: attachment) }
      let(:attachment) { attachment_class.new }
      let(:attachment_class) do
        Class.new do
          def attached?
            true
          end
        end
      end

      before(:each) { allow(subject).to receive(:preview_url) { 'https://test.com/preview' } }

      it { expect(result[:id]).to eq '0' }
      it { expect(result[:text]).to eq 'John Doe' }
      it { expect(result[:detailText]).to eq 'Participant' }
      it { expect(result[:type]).to eq :listItem }
      it { expect(result[:imageURL]).to eq 'https://test.com/preview' }
    end

    context 'image url' do
      let(:result) { subject.mw_stack_list_item(id: 0, text: 'John Doe', detail_text: 'Participant', attachment_url: 'https://test.com/image') }

      it { expect(result[:id]).to eq '0' }
      it { expect(result[:text]).to eq 'John Doe' }
      it { expect(result[:detailText]).to eq 'Participant' }
      it { expect(result[:type]).to eq :listItem }
      it { expect(result[:imageURL]).to eq 'https://test.com/image' }
    end
  end

  describe '#mw_stack_button' do
    context 'url' do
      let(:result) { subject.mw_stack_button(id: 0, label: 'Leave Challenge', url: 'https://test.com/leave', method: :put, on_success: :backward, style: :danger, confirm_title: 'Confirm', confirm_text: 'Are you sure?') }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:type]).to eq :button }
      it { expect(result[:label]).to eq 'Leave Challenge' }
      it { expect(result[:url]).to eq 'https://test.com/leave' }
      it { expect(result[:method]).to eq :put }
      it { expect(result[:onSuccess]).to eq :backward }
      it { expect(result[:style]).to eq :danger }
      it { expect(result[:confirmTitle]).to eq 'Confirm' }
      it { expect(result[:confirmText]).to eq 'Are you sure?' }
    end

    context 'link url' do
      let(:result) { subject.mw_stack_button(id: 0, label: 'Copy & Share Link', link_url: 'https://test.com/share', on_success: :none, style: :textOnly) }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:type]).to eq :button }
      it { expect(result[:label]).to eq 'Copy & Share Link' }
      it { expect(result[:linkURL]).to eq 'https://test.com/share' }
      it { expect(result[:onSuccess]).to eq :none }
      it { expect(result[:style]).to eq :textOnly }
    end

    context 'system links' do
      let(:result) { subject.mw_stack_button(id: 0, label: 'Donate', apple_system_url: 'https://test.com/donate', android_deep_link: 'https://test.com/donate', on_success: :none) }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:type]).to eq :button }
      it { expect(result[:label]).to eq 'Donate' }
      it { expect(result[:appleSystemURL]).to eq 'https://test.com/donate' }
      it { expect(result[:androidDeepLink]).to eq 'https://test.com/donate' }
      it { expect(result[:onSuccess]).to eq :none }
    end

    context 'modal workflow' do
      let(:result) { subject.mw_stack_button(id: 0, label: 'Import', modal_workflow_name: 'Import Activity', on_success: :reload, style: :outline) }

      it { expect(result[:id]).to eq 0 }
      it { expect(result[:type]).to eq :button }
      it { expect(result[:label]).to eq 'Import' }
      it { expect(result[:modalWorkflow]).to eq 'Import Activity' }
      it { expect(result[:onSuccess]).to eq :reload }
      it { expect(result[:style]).to eq :outline }
    end
  end
end
