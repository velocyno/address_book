Rails.application.routes.draw do
  resources :addresses
  root 'static_pages#home'
  get  '/user.json',    to: 'users#index'
end
