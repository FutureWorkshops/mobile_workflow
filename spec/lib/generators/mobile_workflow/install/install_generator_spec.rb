require 'rails_helper'

module MobileWorkflow
  module Generators
    describe InstallGenerator, type: :generator do
      subject { described_class.new }

      describe '#model_property_type' do
        it { expect(subject.send(:model_property_type, {'$ref' => "#/components/schemas/answer"})).to eq 'string' }
        it { expect(subject.send(:model_property_type, {'$ref' => "#/components/schemas/attachment"})).to eq 'attachment' }
      end
    end
  end
end
