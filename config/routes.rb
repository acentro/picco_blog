PiccoBlog::Engine.routes.draw do
  resources :posts do
    resources :comments
  end

  resources :tags, only: [:index, :show]

  get 'posts' => 'posts#index', :as => 'tagged'
  
  root "posts#index"
end
