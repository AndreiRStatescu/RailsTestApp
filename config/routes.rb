Rails.application.routes.draw do
  resources :accounts, only: [:index] do
    member do
      post :join
      delete :leave
    end
    
    # Nested routes for account images
    resources :images, controller: 'account_images', only: [:index, :create, :destroy] do
      collection do
        get :upload
      end
    end
  end
  
  # Route for serving images from Redis
  get "images/:key", to: "account_images#serve", as: :serve_image
  
  get "home/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
