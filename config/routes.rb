Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Session management
      get 'me',  to: 'users#me'
      post 'refresh', to: 'refresh#create'
      post 'signin',  to: 'signin#create'
      delete 'signin',  to: 'signin#destroy'
      # Password reset
      resources :password_resets, only: [:create] do
        collection do
          get ':token', action: :edit, as: :edit
          patch ':token', action: :update
        end
      end
      # Admin
      post 'signup',  to: 'signup#create'
      namespace :admin do
        resources :users, only: [:index, :show, :update, :destroy]
        resources :items, only: [:index, :show, :update, :destroy, :create]
        resources :categories, only: [:index, :show, :update, :destroy, :create]
        resources :terms, only: [:index, :show, :update, :destroy, :create]
        resources :taxes, only: [:index, :show, :update, :destroy, :create]
        resources :withholdings, only: [:index, :show, :update, :destroy, :create]
        resources :tariffs, only: [:index, :show, :update, :destroy, :create]
      end
      # Documentation
      resources :apidocs, only: [:index]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
