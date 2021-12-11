Rails.application.routes.draw do
  resources :user_personalities do
    resources :categories
  end
  devise_for :users
  root 'pages#home'
end
