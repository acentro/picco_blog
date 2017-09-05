PiccoBlog::Engine.routes.draw do

  get 'posts/admin_list' => 'posts#admin_list', :as => 'admin_list'

  resources :posts do
    resources :comments
  end

  resources :tags, only: [:index, :show]

  get 'posts' => 'posts#index', :as => 'tagged'
  
  root "posts#index"
end
