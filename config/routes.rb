Rails.application.routes.draw do
  resources :addresses
  root 'static_pages#home'
  get  '/current_user',    to: 'users#show'
end
