require 'rails_helper'


module MobileWorkflow
  module Generators
    describe ControllerGenerator, type: :generator do
      subject { described_class.new(['mobile_workflow:controller']) }

      describe '#permitted_params' do
        context 'two' do
          before(:each) { allow(subject).to receive(:attributes_names) { ["name", "age"] } }
          it { expect(subject.send(:permitted_params)).to eq ":name, :age" }          
        end

        context 'user' do
          before(:each) { allow(subject).to receive(:attributes_names) { ["name", "age", "user"] } }
          it { expect(subject.send(:permitted_params)).to eq ":name, :age" }          
        end
      end

      # this is generating files
      xit '#copy_controller_and_spec_files' do
        before(:each) { allow(subject).to receive(:doorkeeper_oauth?) { true } }
        it { expect(subject.copy_controller_and_spec_files).to_not be_nil }
      end
      
      describe '#index_action?' do
        before(:each) { allow(subject).to receive(:actions) { ["index"] } }
        it { expect(subject.send(:index_action?)).to eq true }
      end
      
      describe '#show_action?' do
        before(:each) { allow(subject).to receive(:actions) { ["show"] } }
        it { expect(subject.send(:show_action?)).to eq true }
      end
      
      describe '#create_action?' do
        before(:each) { allow(subject).to receive(:actions) { ["create"] } }
        it { expect(subject.send(:create_action?)).to eq true }
      end
    end
  end
end
