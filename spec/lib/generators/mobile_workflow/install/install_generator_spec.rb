require 'rails_helper'

module MobileWorkflow
  module Generators
    describe InstallGenerator, type: :generator do
      
      describe '#generate_controllers_and_routes' do
        let(:open_api_spec_mock) { instance_double(::MobileWorkflow::OpenApiSpec::Parser, controller_name_to_actions: controller_name_to_actions) }
        let(:model_generate) { nil }
        let(:s3_storage) { false }
        let(:doorkeeper_oauth) { false }
        
        before(:each) do
          allow(subject).to receive(:open_api_spec) { open_api_spec_mock }
          allow(subject).to receive(:model_name_to_properties) { model_name_to_properties }
          allow(subject).to receive(:s3_storage?) { s3_storage }
          allow(subject).to receive(:doorkeeper_oauth?) { doorkeeper_oauth }
          expect(subject).to receive(:route).with(controller_route).once()
          expect(subject).to receive(:route).with(root_route).once()
          expect(subject).to receive(:generate).with(model_generate).once() if model_generate
          expect(subject).to receive(:generate).with(controller_generate).once()
        end
        
        context 'no properties' do
          let(:controller_name_to_actions) { {'Cities' => ['index']} }
          let(:model_name_to_properties) { {} }
          let(:controller_route) { "resources :Cities, only: [:index]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:model_generate) { "mobile_workflow:model City text:string" }
          let(:controller_generate) { "mobile_workflow:controller City --actions index --attributes text:string" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
        context 'no properties, index and show' do
          let(:controller_name_to_actions) { {'Cities' => ['index', 'show']} }
          let(:model_name_to_properties) { {} }
          let(:controller_route) { "resources :Cities, only: [:index, :show]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:model_generate) { "mobile_workflow:model City text:string" }
          let(:controller_generate) { "mobile_workflow:controller City --actions index show --attributes text:string" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
        context 'two properties' do
          let(:controller_name_to_actions) { {'Cities' => ['index']} }
          let(:model_name_to_properties) { {'City' => 'name:string population:integer' } }
          let(:controller_route) { "resources :Cities, only: [:index]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:controller_generate) { "mobile_workflow:controller City --actions index --attributes name:string population:integer" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
        context 's3 storage' do
          let(:s3_storage) { true }
          
          let(:controller_name_to_actions) { {'Cities' => ['index']} }
          let(:model_name_to_properties) { {'City' => 'name:string population:integer' } }
          let(:controller_route) { "resources :Cities, only: [:index]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:controller_generate) { "mobile_workflow:controller City --actions index --attributes name:string population:integer --s3-storage" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
        context 'doorkeeper_oauth' do
          let(:doorkeeper_oauth) { true }
          
          let(:controller_name_to_actions) { {'Cities' => ['index']} }
          let(:model_name_to_properties) { {'City' => 'name:string population:integer' } }
          let(:controller_route) { "resources :Cities, only: [:index]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:controller_generate) { "mobile_workflow:controller City --actions index --attributes name:string population:integer --doorkeeper-oauth" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
      end
      
    end
  end
end
