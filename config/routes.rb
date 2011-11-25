LDAP::Application.routes.draw do
  get "operator/schema"

  match 'schema', :controller => 'operator', :action => 'schema'
  resources :users
  root :to => "users#index"
end
