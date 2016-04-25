PiccoBlog::Engine.routes.draw do
  resources :posts do
    resources :comments
  end

  resources :tags, only: [:index, :show]
  
  root "posts#index"
end
