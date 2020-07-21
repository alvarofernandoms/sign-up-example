Rails.application.routes.draw do
  root to: redirect('/login')
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'profile', to: 'users#show'
  get 'profile/edit', to: 'users#edit'

  resources :users
  resources :sessions
end
