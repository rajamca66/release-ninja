Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "oauth_callbacks" }

  namespace :api do
    resources :projects

    namespace :github do
      resources :repositories, only: [:index]
    end
  end

  get "*path", to: "application#index"
  root 'application#index'
end
