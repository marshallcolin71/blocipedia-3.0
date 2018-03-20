Rails.application.routes.draw do
  devise_for :users

  resources :wikis

  root 'welcome#index'
end
