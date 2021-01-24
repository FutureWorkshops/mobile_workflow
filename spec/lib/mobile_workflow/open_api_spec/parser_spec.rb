require 'rails_helper'

module MobileWorkflow
  module OpenApiSpec
    describe Parser do
      subject { described_class.new(open_api_spec.to_json) }
      let(:open_api_spec) { {} }

      describe '#model_property_type' do
        it { expect(subject.send(:model_property_type, {'type' => "string"})).to eq 'string' }
        it { expect(subject.send(:model_property_type, {'$ref' => "#/components/schemas/attachment"})).to eq 'attachment' }
      end
      
      describe '#controller_names' do
        context 'index, show paths' do
          before(:each) { allow(subject).to receive(:paths) {["/items", "/items/{item_id}"]} }
          it { expect(subject.send(:controller_names)).to eq ["items"]}
        end
      end
    end
  end
end