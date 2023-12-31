Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get 'users/show'
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :update]
  namespace :admin do
    resources :users
  end
  resources :tags, only: [:create, :destroy]
end
