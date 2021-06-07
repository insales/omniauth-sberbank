Rails.application.routes.draw do
  # get 'session/create'

  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/auth/vkontakte/callback', to: 'sessions#create'
  get '/auth/vkontakte/callback', to: 'sessions#create'
  post '/auth/sberbank/callback', to: 'sessions#create'
  get '/auth/sberbank/callback', to: 'sessions#create'
  get '/check_connection', to: 'sessions#sendiboba'
  post '/check_connection', to: 'sessions#sendiboba'
  get '/auth/:provider/callback', to: 'sessions#auth_hash'
end
