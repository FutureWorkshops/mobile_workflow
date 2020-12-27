require 'rails_helper'

module MobileWorkflow
  module Generators
    describe ControllerGenerator, type: :generator do
      let(:args) { [name] }
      let(:name) { 'mobile_workflow:controller' }
      subject { described_class.new(args) }

      describe '#permitted_params' do
        before(:each) { allow(subject).to receive(:attributes_names) { ["name", "age"] } }
        it { expect(subject.send(:permitted_params)).to eq ":name, :age" }
      end
    end
  end
end
