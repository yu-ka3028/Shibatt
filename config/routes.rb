Rails.application.routes.draw do
  root "static_pages#top"

  resources :users do
    resources :memos, only: [:index, :create, :show, :update, :destroy] do
      member do
        patch :update_tag
      end
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
  # delete 'logout', to: 'user_sessions#destroy', as: 'logout'
  get 'logout', to: 'user_sessions#destroy', as: 'logout'

  get "memos/tag_search", to: "memos#tag_search", as: "tag_search"
  
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  post '/', to: 'linebot#callback'
  post '/webhook', to: 'linebot#callback'
end
