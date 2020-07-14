MobileWorkflow::Engine.routes.draw do
  resources :sns_notifications, only: :create
end
