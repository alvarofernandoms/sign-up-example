Rails.application.routes.draw do
  root to: redirect('/login')

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'forgot', to: 'sessions#forgot', as: 'forgot'

  get 'recovery', to: 'users#recovery', as: 'recovery'
  patch 'recovery', to: 'users#update_password', as: 'recovery_update'
  post 'forgot', to: 'users#password_reset_request', as: 'forgot_path'
  get 'signup', to: 'users#new', as: 'signup'
  get 'profile', to: 'users#show'
  get 'profile/edit', to: 'users#edit'

  resources :users
  resources :sessions
end
