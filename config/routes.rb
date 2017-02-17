Rails.application.routes.draw do
  ###############
  ## Localized ##
  ###############
  scope '/:locale', locale: /#{I18n.available_locales.join('|')}/ do
    root to: 'static_pages#index'

    ###############
    ## Resources ##
    ###############

    resources :users
    resources :sessions,        only: [:new, :create, :destroy]
    resources :authentications, only: [:destroy]

    ##################
    ## Static Pages ##
    ##################

    get 'about'   => 'static_pages#about',   as: 'about'
    get 'motd'    => 'static_pages#motd',    as: 'motd'
    get 'contact' => 'static_pages#contact', as: 'contact'
    get 'terms'   => 'static_pages#terms',   as: 'terms'
    get 'privacy' => 'static_pages#privacy', as: 'privacy'

    #####################
    ## User / Sessions ##
    #####################

    get  'login'  => 'sessions#new',     as: 'login'
    post 'logout' => 'sessions#destroy', as: 'logout'
    get  'signup' => 'users#new',        as: 'signup'
  end

  #####################
  ## No Localization ##
  #####################

  post 'oauth/callback/:provider' => 'oauth#callback', provider: /facebook|google|microsoft|twitter/
  get  'oauth/callback/:provider' => 'oauth#callback', provider: /facebook|google|microsoft|twitter/

  post 'oauth/signup'          => 'oauth#provider_signup', as: 'provider_signup'
  get  'oauth/:provider'       => 'oauth#oauth',           as: 'auth_at_provider', provider: /facebook|google|microsoft|twitter/
  get  'users/:token/activate' => 'users#activate',        as: 'activate_user'

  ['404','422','500'].each do |code|
    get code, to: "errors#show", code: code
  end

  ####################
  ## Catchall Paths ##
  ####################

  root to: redirect("/#{I18n.default_locale}", status: 302), as: :redirected_root

  get "/*path", to: redirect("/#{I18n.default_locale}/%{path}", status: 302), constraints: {path: /(?!(#{I18n.available_locales.join("|")})\/).*/}, format: false
  get '*unmatched_route', to: 'errors#show', code: 404
end
