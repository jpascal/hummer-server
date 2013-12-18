UUID ||= /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-(:?8|9|a|b)[a-f0-9]{3}-[a-f0-9]{12}/i

Hummer::Application.routes.draw do

  # All time verify id param by UUID pattern
  constraints :id => UUID do

    # API controllers
    namespace :api, :module => :api, :constraints => { :format => 'json' } do
      resources :projects, :only => [:index,:show] do
        resources :suites, :only => [:create,:index]
      end
      resources :suites, :only => [:index,:show]
      resources :features, :only => [:index,:show]
    end

    # Login/logout routes
    get :login, :controller => :sessions, :action => :new
    post :login, :controller => :sessions, :action => :create
    get :logout, :controller => :sessions, :action => :destroy

    # Signup routes
    get :signup, :controller => :users, :action => :new
    post :signup, :controller => :users, :action => :create

    # Password recovery routes
    resources :recoveries, :except => :index

    # Bug routes
    resources :bugs, :only => [:index, :show]

    # User resource routes
    resources :users do
      member do
        get :token
      end
      collection do
        get :search
      end
    end

    # Project resource routes
    resources :projects do
      # Suite resource routes inside Project
      resources :suites do
        member do
          get :reload
          get :search
          get :paste
        end
        # Case resource routes inside Suite
        resources :cases, :only => :show do
          # Allow create/delete/edit bugs
          # TODO: refactor to
          # resource :bug { member { get :paste } }
          resource :tracker, :only => [:show, :edit, :update], :controller => :trackers
          member do
            get :paste
          end
        end
        # Routes to compare functionality
        resources :compares, :only => [:index, :show]
      end
    end

    # Dashboard
    root :to => 'root#index'
  end
end
