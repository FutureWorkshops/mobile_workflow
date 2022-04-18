# frozen_string_literal: true

Rails.application.routes.draw do
  mount MobileWorkflow::Engine => '/mobile_workflow'
end
