Rails.application.routes.draw do
  resources :user_personalities do
    get '/graphics', to: 'pages#graphics'
    resources :categories, except: :index do
      resources :transactions, except: %i[index show] do
        resources :notes
      end
    end
  end
  devise_for :users
  root 'pages#home'
end
