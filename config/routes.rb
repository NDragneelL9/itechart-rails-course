Rails.application.routes.draw do
  resources :user_personalities do
    resources :categories, except: :index do 
      resources :transactions, except: %i[index show]
    end
  end
  devise_for :users
  root 'pages#home'
end
