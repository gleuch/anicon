Anicon::Application.routes.draw do

  # Photos
  # /photos
  resources :photos,  :only => [:index, :new, :create, :destroy, :show] do
    member do
      get :download, :upload
    end

    collection do
      get :gallery
    end
  end

  # Sessions
  # /sessions
  get 'sessions/callback', :to => 'sessions#callback', :as => 'callback'
  resources :sessions

  # Default home => as /photos
  # /
  root :to => 'photos#index'


end
