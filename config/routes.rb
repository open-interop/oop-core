Rails.application.routes.draw do
  namespace :services do
    namespace :v1 do
      get 'devices/auth', to: 'devices#auth'
      get 'devices/:id/temprs', to: 'devices#temprs'

      get 'schedules', to: 'schedules#index'
      get 'schedules/:id/temprs', to: 'schedules#temprs'

      get 'blacklist_entries', to: 'blacklist_entries#index'

      get 'accounts', to: 'accounts#index'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'dashboards/transmissions', to: 'dashboards#transmissions'
      get 'dashboards/messages', to: 'dashboards#messages'

      resources :audits, only: %i[index show]

      resources :users do
        member do
          get 'history', to: 'users#history'
        end
      end

      resources :device_temprs, only: %i[index create destroy]
      resources :schedule_temprs, only: %i[index create destroy]

      resources :tempr_layers, only: %i[index create destroy]

      resources :device_groups do
        member do
          get 'history', to: 'device_groups#history'
        end
      end

      resources :temprs do
        member do
          get 'history', to: 'temprs#history'
        end

        collection do
          post 'preview', to: 'temprs#preview'
        end
      end

      resources :sites do
        collection do
          get 'sidebar', to: 'sites#sidebar'
        end

        member do
          get 'history', to: 'sites#history'
        end
      end

      resources :layers do
        member do
          post 'assign_tempr', to: 'layers#assign_tempr'
          get 'history', to: 'layers#history'
        end
      end

      resources :blacklist_entries do
        member do
          get 'history', to: 'blacklist_entries#history'
        end
      end

      resources :devices do
        member do
          post 'assign_tempr', to: 'devices#assign_tempr'
          get 'history', to: 'devices#history'
        end
      end

      resources :schedules do
        member do
          post 'assign_tempr', to: 'schedules#assign_tempr'
          get 'history', to: 'schedules#history'
        end
      end

      get 'transmissions', to: 'transmissions#index'
      get 'transmissions/:id', to: 'transmissions#show'

      get 'messages', to: 'messages#index'
      get 'messages/:id', to: 'messages#show'

      post 'passwords', to: 'passwords#create'
      post 'passwords/reset', to: 'passwords#reset'

      post 'auth/login', to: 'sessions#create'
      get 'me', to: 'sessions#me'
    end
  end

  get '/*a', to: 'application#not_found'
end
