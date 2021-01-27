require 'rails_helper'

module MobileWorkflow
  module Generators
    describe InstallGenerator, type: :generator do
      
      describe '#generate_controllers_and_routes' do
        let(:open_api_spec_mock) { instance_double(::MobileWorkflow::OpenApiSpec::Parser, controller_names: [controller_name]) }
        let(:model_generate) { nil }
        
        before(:each) do
          allow(subject).to receive(:open_api_spec) { open_api_spec_mock }
          allow(subject).to receive(:model_name_to_properties) { model_name_to_properties }
          expect(subject).to receive(:route).with(controller_route).once()
          expect(subject).to receive(:route).with(root_route).once()
          expect(subject).to receive(:generate).with(model_generate).once() if model_generate
          expect(subject).to receive(:generate).with(controller_generate).once()
        end
        
        context 'no properties' do
          let(:controller_name) { 'Cities' }
          let(:model_name_to_properties) { {} }
          let(:controller_route) { "resources :Cities, only: [:index, :show, :create]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:model_generate) { "mobile_workflow:model City text:string" }
          let(:controller_generate) { "mobile_workflow:controller City --attributes text:string" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
        context 'two properties' do
          let(:controller_name) { 'Cities' }
          let(:model_name_to_properties) { {'City' => 'name:string population:integer' } }
          let(:controller_route) { "resources :Cities, only: [:index, :show, :create]" } 
          let(:root_route) { "root to: 'admin/Cities#index'" }
          let(:controller_generate) { "mobile_workflow:controller City --attributes name:string population:integer" }
          
          it { expect(subject.generate_controllers_and_routes).to_not be_nil }
        end
        
      end
      
    end
  end
end
