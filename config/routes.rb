Anicon::Application.routes.draw do

  # Photos
  # /photos
  resources :photos,  :only => [:index, :new, :create, :destroy, :show] do
    member do
      get :download
    end
  end

  # Default home => as /photos
  # /
  root :to => 'photos#index'


end
