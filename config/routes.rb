Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "oauth_callbacks" }

  namespace :api do
    resources :projects do
      resources :notes
    end

    namespace :github do
      resources :repositories, only: [:index]
    end
  end

  namespace :public do
    get "/:id" => "notes#show"
  end

  get "*path", to: "application#index"
  root 'application#index'
end
