Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do # /api/data
    get '/data', to: 'tests#index'

    resources :products, only: [:create, :index, :update]
  end

  mount ActionCable.server => '/cable'
end
