# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index', as: :landing_page

  get 'register', to: 'users#new'
  
  post '/users', to: 'users#create', as: :users_path
  
  get '/login', to: 'users#login_form'

  post '/login', to: 'users#login_user', as: :user_login

  delete  '/logout', to: 'users#destroy', as: :logout

  get '/dashboard', to: 'users#show', as: :dashboard

  get '/movies', to: 'movies#index', as: :user_movies

  get '/discover', to: 'movies#search', as: :user_discover

  get '/movies/:id', to: 'movies#show', as: :user_movie

  get '/movies/:id/parties', to: 'viewing_parties#new', as: :new_user_movie_viewing_party

  post '/movies/:id/parties', to: 'viewing_parties#create', as: :user_movie_viewing_parties

  resources :users do
    resources :movies do
      resources :viewing_parties, only: %i[new create]
    end
  end
end
