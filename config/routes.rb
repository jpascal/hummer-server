Hummer::Application.routes.draw do


  # API controllers
  namespace :api, :module => :api, :constraints => { :format => 'json' } do
    resources :projects, :only => [:index,:show] do
      resources :suites, :only => [:create,:index]
    end
    resources :suites, :only => [:index,:show]
    resources :features, :only => [:index,:show]
  end

  # Regular web requests

  get :login, :controller => :sessions, :action => :new
  post :login, :controller => :sessions, :action => :create
  get :logout, :controller => :sessions, :action => :destroy

  get :signup, :controller => :users, :action => :new
  post :signup, :controller => :users, :action => :create

  resources :recoveries, :except => :index
  resources :bugs, :only => [:index, :show]
  resources :users do
    member do
      get :token
    end
    collection do
      get :search
    end
  end
  resources :projects do
    resources :suites, :only => [:edit, :update, :create, :destroy, :new, :index, :show], :as => :suites do
      member do
        get :reload
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
  end
  resources :suites, :only => :index

  root :to => 'root#index'

end
