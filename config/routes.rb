Rails.application.routes.draw do
  root "static_pages#top"

  resources :users do
    resources :memos, only: [:index, :create, :show, :update, :destroy] do
    end
  end

  resources :reflection_memos do
    get 'new_lastweek', on: :collection
  end


  get 'privacy_policy', to: 'static_pages#privacy_policy', as: 'privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'contact_form', to: 'static_pages#contact_form'
  
  get "sign_up", to: "users#new"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get "memos/tag_search", to: "memos#tag_search", as: "tag_search"

  get 'oauths/oauth', to: 'oauths#oauth'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: 'oauth'
  post "oauth/callback", to: "oauths#callback"
  # get 'oauth/:provider/callback', to: 'oauths#callback', as: 'oauth_callback'
  
  post '/' => 'linebot#callback'
  post '/webhook', to: 'linebot#callback'
  

end