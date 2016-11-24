Rails.application.routes.draw do

  get 'setup', controller: :pages, action: :redirect
  get 'callback', controller: :pages, action: :callback
  root controller: :pages, action: :index

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
