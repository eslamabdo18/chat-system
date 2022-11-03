Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      require 'sidekiq/web'
      mount Sidekiq::Web => "/sidekiq"
      resources :applications, param: :app_token, only: [:index, :show, :create, :update] do
        resources :chats, param: :number, only: [:index, :show] do 
          resources :messages, param: :number, only: [:index, :show] do
            collection do
              get :search
            end
          end
        end
      end
    end
  end
end
