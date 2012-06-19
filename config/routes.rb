LDAP::Application.routes.draw do
  get "operator/schema"

#  get 'logout' => 'sessions#destroy'
#  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'schema' => 'operator#schema'

  resources :reports, :only => [:show,:index]
  #match "/reports/:id.:format)", :to => "reports#show"

  resources :days
  resources :accounts

  root :to => "operator#schema"
end
