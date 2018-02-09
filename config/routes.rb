Rails.application.routes.draw do
  root 'application#main'
  get '/:id', to: 'v1/urls#redirect'

  namespace :v1 do
    resources :urls
  end
end
