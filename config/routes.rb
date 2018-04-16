Rails.application.routes.draw do
  get 'downgrade/new'

  get 'downgrade/create'

  get 'charges/create'

  get 'charges_controller/create'

  devise_for :users

  resources :charges, only: [:new, :create]

  resources :downgrade, only: [:new, :create]

  post 'downgrade/create'

  resources :wikis

  root 'welcome#index'
end
