LDAP::Application.routes.draw do
  get "operator/schema"

  match 'schema', :controller => 'operator', :action => 'schema'
  resources :days
  resources :users
  root :to => "operator#schema"
end
