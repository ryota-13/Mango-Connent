Rails.application.routes.draw do

  # ユーザー認証
  devise_for :users, skip: [:passwords], controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in', as: 'user_guest_sign_in'
  end

  # 管理者認証
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # Public側
  scope module: :public do
    # トップページ・その他ページ
    root 'homes#top'
    get 'about', to: 'homes#about'
    get 'search', to: 'searches#search', as: 'search'
    get 'mypage', to: 'users#mypage'
    get 'feed', to: 'users#feed', as: 'feed'
    # ユーザー
    resources :users, only: [:show, :edit, :update, :destroy] do
      # フォロー・フォロワー関連
      resource :relationships, only: [:create, :destroy] 
      get "followings", to: "relationships#followings", as: "followings"  # フォロー一覧
      get "followers", to: "relationships#followers", as: "followers"  # フォロワー一覧
    end

    resources :follows, only: [:index] 
  
    # 投稿
    resources :posts do
      # コメント
      resources :comments, only: [:create, :destroy]
  
      # いいね
      resources :favorites, only: [:create, :destroy]
    end
    resources :favorites, only: [:index]
  end
  

  # Admin側
  namespace :admin do
    # 管理者トップページ
    root 'homes#top'

    # ユーザー管理
    resources :users, only: [:index, :show, :destroy]

    # 投稿管理
    resources :posts, only: [:index, :show, :destroy] do
      resources :comments, only: [:destroy]
    end  
  end
end




