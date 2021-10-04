require 'rails_helper'

describe MobileWorkflow::Displayable::Steps::PieChart do
  let(:test_class) { Struct.new(:id) { include MobileWorkflow::Displayable } }
  let(:id) { 1 }

  subject { test_class.new(id) }

  describe '#mw_pie_chart_item' do
    let(:result) { subject.mw_pie_chart_item(id: 1, label: 'Apples', value: 10) }
    it { expect(result[:id]).to eq 1 }
    it { expect(result[:label]).to eq 'Apples' }
    it { expect(result[:value]).to eq 10 }
  end
end
