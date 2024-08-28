Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create] do
        resources :links, only: %i[create index]
      end
      resources :sessions, only: %i[create]
      resources :links, only: %i[index], action: :show
      resources :tags, only: %i[index create destroy]
      get 'top_links', to: 'links#top_links'
    end
  end
end
