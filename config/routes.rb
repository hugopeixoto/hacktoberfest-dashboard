Rails.application.routes.draw do
  root 'home#index'

  post '/register', to: 'home#register'
end
