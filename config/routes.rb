Hummer::Application.routes.draw do

  get :login, :controller => :sessions, :action => :new
  post :login, :controller => :sessions, :action => :create
  get :logout, :controller => :sessions, :action => :destroy

  resources :reports, :except => [:edit, :update] do
    member do
      get :paste
    end
    resources :cases, :only => :show do
      member do
        get :paste
      end
    end
  end

  root :to => 'root#index'

end
