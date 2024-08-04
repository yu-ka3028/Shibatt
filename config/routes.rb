Rails.application.routes.draw do
  root "static_pages#top"

  resources :users do
    resources :memos do
      # resources :reflection_memos
    end
  end
  
  get "sign_up", to: "users#new"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get 'reflection_memos/new', to: 'reflection_memos#new', as: 'new_reflection_memo'
  post 'reflection_memos', to: 'reflection_memos#create', as: 'reflection_memos'
  get 'reflection_memos', to: 'reflection_memos#index', as: 'reflection_memos_index'
  get 'reflection_memos/:id/edit', to: 'reflection_memos#edit', as: 'edit_reflection_memo'
  patch 'reflection_memos/:id', to: 'reflection_memos#update', as: 'reflection_memo'

  get "memos/tag_search", to: "memos#tag_search", as: "tag_search"
end
