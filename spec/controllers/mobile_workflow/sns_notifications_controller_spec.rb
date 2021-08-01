require 'rails_helper'

describe MobileWorkflow::SnsNotificationsController do
  
  routes { MobileWorkflow::Engine.routes }

  describe '#create' do
    let(:message) { {"Type" => "Notification", "Records" => [{"s3" => {"object" => {"key" => key}}}]} }
    let(:message_body) { {"Type" => "Notification"} }
    let(:key) { 'Class/id/property' }
    
    before(:each) do
      allow(subject).to receive(:message) { message }
      allow(subject).to receive(:message_body) { message_body }
      allow(subject).to receive(:verify_request_authenticity) {} 
      post :create
    end
    
    xit { expect(response).to be_successful }
  end
  
  describe '#key_identifiers' do
    let(:object_key) { 'Expense/1/image/0c17b7a5-1e93-401e-9d96-6439ecc55b35.jpg' }
    before { allow(subject).to receive(:object_key) { object_key } }
    it { expect(subject.send(:key_identifiers)).to eq ['Expense', '1', 'image'] }
  end
end