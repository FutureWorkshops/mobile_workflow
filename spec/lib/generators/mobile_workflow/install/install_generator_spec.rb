require 'rails_helper'

module MobileWorkflow
  module Generators
    describe InstallGenerator, type: :generator do
      subject { described_class.new }

      describe '#model_property_type' do
        it { expect(subject.send(:model_property_type, {'type' => "string"})).to eq 'string' }
        it { expect(subject.send(:model_property_type, {'$ref' => "#/components/schemas/attachment"})).to eq 'attachment' }
      end
      
      describe '#controller_names' do
        context 'index, show paths' do
          before(:each) { allow(subject).to receive(:oai_spec_paths) {["/items", "/items/{item_id}"]} }
          it { expect(subject.send(:controller_names)).to eq ["items"]}
        end
      end
    end
  end
end
