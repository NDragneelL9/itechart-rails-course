Rails.application.routes.draw do
  resources :user_personalities do
    resources :categories do 
      resources :transactions, shallow: true
    end
  end
  devise_for :users
  root 'pages#home'
end
