Rails.application.routes.draw do
  resources :user_personalities
  devise_for :users
  root 'pages#home'
end
