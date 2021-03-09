require 'rails_helper'

module MobileWorkflow
  module OpenApiSpec
    describe Parser do
      subject { described_class.new(open_api_spec.to_json) }
      let(:open_api_spec) { {} }

      describe '#model_property_type' do
        it { expect(subject.send(:model_property_type, {'type' => "string"})).to eq 'string' }
        it { expect(subject.send(:model_property_type, {'$ref' => "#/components/schemas/MWAttachment"})).to eq 'attachment' }
      end
      
      describe '#controller_name_to_actions' do
        before(:each) { allow(subject).to receive(:open_api_spec) { open_api_spec.with_indifferent_access } }    

        context 'index' do
          let(:open_api_spec) { {paths: {'/appointments': {'get': {}}}} }
          it { expect(subject.controller_name_to_actions).to eq({"appointments" => ['index']}) }
        end
        
        context 'show' do
          let(:open_api_spec) { {paths: {'/appointments/{appointment_id}': {'get': {}}}} }
          it { expect(subject.controller_name_to_actions).to eq({"appointments" => ['show']}) }
        end
        
        context 'create' do
          let(:open_api_spec) { {paths: {'/appointments': {'post': {}}}} }
          it { expect(subject.controller_name_to_actions).to eq({"appointments" => ['create']}) }
        end
      end
    end
  end
end