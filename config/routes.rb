Rails.application.routes.draw do
  get 'courses/new'

  get 'users/new'
  get 'users/search'

  get 'static_pages/home'

  get 'static_pages/help'

  get 'static_pages/search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :courses
  # root to: 'static_pages#home'
  # match '/signup', to: 'courses#new', via: 'get'
end
