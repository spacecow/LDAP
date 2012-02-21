LDAP::Application.routes.draw do
  get "operator/schema"
  get "operator/reports"
  get "operator/report"

  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'schema' => 'operator#schema'
  get 'reports' => 'operator#reports'
  get 'report' => 'operator#report'
  resources :days
  resources :accounts

  root :to => "sessions#new"
end
