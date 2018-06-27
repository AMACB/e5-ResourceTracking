Rails.application.routes.draw do

  get       '/'                 => 'pages#home'

  get       'items/manage'      => 'items#manage', as: :items_manage
  resources :items, only: [:index, :create, :show, :update, :destroy]

# get       'items'             => 'items#index'
# post      'items'             => 'items#create'
# get       'items/:id'         => 'items#show'
# patch     'items/:id'         => 'items#update'
# delete    'items/:id'         => 'items#destroy'


  resources :users, only: [:create]
  get       'signup'            => 'users#new'
  get       'login'             => 'sessions#new'
  post      'login'             => 'sessions#create'
  delete    'logout'            => 'sessions#destroy'


  resources :checkout

  get       'checkouts'         => 'checkouts#index'
  resources :checkout_items, only: [:create, :update, :destroy]

  get       'cart'              => 'carts#show', as: :cart
  get       'cart/checkout'     => 'carts#checkout_begin', as: :checkout_begin
  patch     'cart/checkout'     => 'carts#checkout_end', as: :checkout_end

end