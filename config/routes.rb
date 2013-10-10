Hummer::Application.routes.draw do

  get :login, :controller => :sessions, :action => :new
  post :login, :controller => :sessions, :action => :create
  get :logout, :controller => :sessions, :action => :destroy

  get :signup, :controller => :users, :action => :new
  post :signup, :controller => :users, :action => :create

  resources :suites, :except => [:edit, :update], :as => :suites do
    member do
      get :search
      get :paste
    end
    resources :compares, :only => [:index, :show]
    resources :cases, :only => :show do
      resource :tracker, :only => [:show, :edit, :update], :controller => :trackers
      member do
        get :paste
      end
    end
  end

  root :to => 'root#index'

end
