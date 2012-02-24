LDAP::Application.routes.draw do
  get "operator/schema"

  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'schema' => 'operator#schema'

  resources :reports, :only => [:show,:index]
  resources :days
  resources :accounts

  root :to => "sessions#new"
end
