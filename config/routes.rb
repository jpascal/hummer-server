Hummer::Application.routes.draw do
  root :to => 'root#index'
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
end
