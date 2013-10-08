Hummer::Application.routes.draw do
  root :to => 'root#index'
  resources :reports, :except => [:edit, :update]
end
