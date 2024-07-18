Rails.application.routes.draw do
  root "static_pages#top"

  resources :users, only: %i[new create] do
    resources :memos do
      # resources :reflection_memos
    end
  end
  
  get 'login', to: 'user_sessions#new'
  get "sign_up", to: "users#new"
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get 'reflection_memos/new', to: 'reflection_memos#new', as: 'new_reflection_memo'
  post 'reflection_memos', to: 'reflection_memos#create', as: 'reflection_memos'
  get 'reflection_memos', to: 'reflection_memos#index', as: 'reflection_memos_index'

end
