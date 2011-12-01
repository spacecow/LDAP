LDAP::Application.routes.draw do
  get "operator/schema"

  match 'schema', :controller => 'operator', :action => 'schema'
  resources :days
  resources :accounts
  root :to => "operator#schema"
end
