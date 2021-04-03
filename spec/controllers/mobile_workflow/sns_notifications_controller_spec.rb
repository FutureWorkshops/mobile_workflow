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
end