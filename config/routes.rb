Rails.application.routes.draw do
  resources :courses
  resources :users do
    member do
      get :following, :followers
      get :lessons
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :relatecourses, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
  # get 'users/index', to: 'user#new', via: 'get'

  root to: 'static_pages#home'

  # get 'courses/new'
  # get 'courses/index'

  match '/microposts', to: 'static_pages#home', via: 'get'

  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/sessions', to: 'sessions#back_to_signin', via:'get'
  # match '/users', to:'users#new', via:'get'

  get 'static_pages/home'
  match '/home', to: 'static_pages#home', via: 'get'
  # get 'static_pages/help'
  match '/help', to: 'static_pages#help', via: 'get'
  # get 'static_pages/about'
  match '/about', to: 'static_pages#about', via: 'get'
  # get 'static_pages/contact'
  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/search', to: 'users#search', via: 'get'
  #match '/search', to: 'courses#search', via: 'post'
  match '/index', to:'courses#index', via: 'get'

  match '/updateass', to: 'courses#update_assignments', via: 'get'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
