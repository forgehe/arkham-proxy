Rails.application.routes.draw do
  root 'proxy#show'
  get 'proxy#send_data', to: 'proxy#show'
  post '/deck', to: 'proxy#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
