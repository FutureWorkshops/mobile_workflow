require 'rails_helper'

module MobileWorkflow
  module Generators
    describe ControllerGenerator, type: :generator do
      let(:args) { [name] }
      let(:name) { 'mobile_workflow:controller' }
      subject { described_class.new(args) }

      describe '#rewrite_params' do
        before(:each) { allow(subject).to receive(:attributes_names) { nil } }
        it { expect(subject.send(:rewrite_params)).to eq nil }
      end
    end
  end
end
