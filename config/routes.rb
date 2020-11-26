Rails.application.routes.draw do
  devise_for :users


  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    resources :friendships, only: [ :create ]
  end


  resources :midways, only: [:index, :new, :create, :edit, :update]
  
  get 'dashboard', to: 'pages#dashboard', as: 'dashboard'
  get 'users/:id' => 'users#show', as: "user_profile"
  get 'friends', to: 'users#friends', as: 'friends'

end
