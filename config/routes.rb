Hummer::Application.routes.draw do

  get :login, :controller => :sessions, :action => :new
  post :login, :controller => :sessions, :action => :create
  get :logout, :controller => :sessions, :action => :destroy

  get :signup, :controller => :users, :action => :new
  post :signup, :controller => :users, :action => :create

  resources :recoveries, :except => :index

  resources :users do
    collection do
      get :search
    end
  end
  resources :projects
  resources :suites, :only => [:edit, :update, :create, :destroy, :new, :index, :show], :as => :suites do
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
