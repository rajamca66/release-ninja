Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "oauth_callbacks" }

  root 'application#index'
end
