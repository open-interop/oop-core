Rails.application.routes.draw do
  resources :device_temprs
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :services do
    namespace :v1 do
      get 'devices/auth', to: 'devices#auth'
      get 'devices/:id/temprs', to: 'devices#temprs'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users
      resources :device_groups do
        resources :temprs
      end
      resources :sites
      resources :devices do
        member do
          post 'assign_tempr', to: 'devices#assign_tempr'
        end

        resources :device_temprs
      end

      post '/auth/login', to: 'sessions#create'
      get '/*a', to: 'application#not_found'
    end
  end
end
