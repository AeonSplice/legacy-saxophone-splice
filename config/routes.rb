Rails.application.routes.draw do
  root to: 'static_pages#index'

  ###############
  ## Resources ##
  ###############

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  ###################
  ## Landing Pages ##
  ###################

  get 'about'   => 'static_pages#about',   as: 'about'
  get 'motd'    => 'static_pages#motd',    as: 'motd'
  get 'contact' => 'static_pages#contact', as: 'contact'

  #####################
  ## User / Sessions ##
  #####################

  get  'login'    => 'sessions#new',      as: 'login'
  post 'logout'   => 'sessions#destroy',  as: 'logout'
  get  'signup'   => 'users#new',         as: 'signup'

  get 'users/:token/activate' => 'users#activate', as: 'activate_user'
end
