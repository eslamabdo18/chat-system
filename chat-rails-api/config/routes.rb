Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :applications, param: :access_token, only: [:index, :show, :create, :update]
    end
  end
end
