Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "oauth_callbacks" }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :api do
    resources :projects do
      resources :hooks
      resources :notes
      resources :reports do
        member do
          post :add_note
          delete :remove_note
          get :html
        end
      end
    end

    resources :invites

    namespace :github do
      resources :repositories, only: [:index]
      resources :pull_requests, only: [:index]
    end
  end

  namespace :public do
    get "/:id" => "notes#show"
  end

  match "/hook", to: "hooks#perform", via: [:get, :post]

  constraints lambda { |req| req.subdomain.present? && req.subdomain != "www" }  do
    get '' => 'public/notes#show'
    get '*path' => 'public/notes#show'
  end

  get "*path", to: "application#index"
  root 'application#index'
end
