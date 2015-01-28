Rails.application.routes.draw do
  devise_for :users, only: []
  devise_for :reviewers, only: []

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/auth/:provider', to: lambda{|env| [404, {}, ["Not Found"]]}, as: 'auth'
  get '/auth/:provider/callback', to: 'oauth_callbacks#create'

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

  resources :reviews do
    collection do
      get "create", action: :create, as: :create
    end
  end

  resource :healths

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
