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

      resources :audit_logs, only: %i[index show]

      get 'account', to: 'account#show', as: 'account'
      put 'account', to: 'account#update'

      resources :users do
        member do
          get 'audit_logs', to: 'users#audit_logs'
        end
      end

      resources :device_temprs, only: %i[index create destroy]
      resources :schedule_temprs, only: %i[index create destroy]

      resources :tempr_layers, only: %i[index create destroy]

      resources :device_groups do
        member do
          get 'audit_logs', to: 'device_groups#audit_logs'
        end
      end

      resources :temprs do
        member do
          get 'audit_logs', to: 'temprs#audit_logs'
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
          get 'audit_logs', to: 'sites#audit_logs'
        end
      end

      resources :layers do
        member do
          post 'assign_tempr', to: 'layers#assign_tempr'
          get 'audit_logs', to: 'layers#audit_logs'
        end
      end

      resources :blacklist_entries do
        member do
          get 'audit_logs', to: 'blacklist_entries#audit_logs'
        end
      end

      resources :devices do
        member do
          post 'assign_tempr', to: 'devices#assign_tempr'
          get 'audit_logs', to: 'devices#audit_logs'
        end
      end

      resources :schedules do
        member do
          post 'assign_tempr', to: 'schedules#assign_tempr'
          get 'audit_logs', to: 'schedules#audit_logs'
        end
      end

      get 'transmissions', to: 'transmissions#index'
      get 'transmissions/:id', to: 'transmissions#show'
      post 'transmissions/:id/retry', to: 'transmissions#retry'

      get 'messages', to: 'messages#index'
      get 'messages/:id', to: 'messages#show'
      post 'messages/:id/retry', to: 'messages#retry'

      post 'passwords', to: 'passwords#create'
      post 'passwords/reset', to: 'passwords#reset'

      post 'auth/login', to: 'sessions#create'
      get 'me', to: 'sessions#me'
    end
  end

  get '/*a', to: 'application#not_found'
end
