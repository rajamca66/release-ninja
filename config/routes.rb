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

      resources :reviewers
    end

    resources :invites

    namespace :github do
      resources :repositories, only: [:index]
      resources :pull_requests, only: [:index]
    end

    resources :repositories
    resources :reviews
  end

  get "/plain/:id" => "projects#plain", as: :report
  get "/help" => "help#index", as: :help

  resource :healths

  namespace :public do
    get "/:id" => "notes#show"
  end

  match "/hook", to: "hooks#perform", via: [:get, :post]

  subdomain_constraint_params = lambda do |req|
    skip_words = ["herokuapp", "ngrok"]
    skip = skip_words.any?{ |word| req.domain.include?(word) || req.subdomain.include?(word) }
    top = req.subdomains.first

    if skip
      false
    else
      top.present? && top != "www"
    end
  end

  constraints subdomain_constraint_params do
    get '' => 'public/notes#show'
    get '*path' => 'public/notes#show'
  end

  get "/reviews/create" => redirect(path: '/workflow/review')
  get "/workflow/review", to: "application#index", as: :workflow_review
  get "*path", to: "application#index"
  root 'application#index'
end
