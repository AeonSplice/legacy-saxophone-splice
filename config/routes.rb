Rails.application.routes.draw do
  root to: 'landing_pages#index'
  get 'about' => 'landing_pages#about', as: 'about'
  get 'motd' => 'landing_pages#motd', as: 'motd'
end
