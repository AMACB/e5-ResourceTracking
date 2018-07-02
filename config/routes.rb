Rails.application.routes.draw do

  get       '/'                 => 'pages#home'

  get       'items/manage'      => 'items#manage', as: :items_manage
  get       'catalog'           => 'items#catalog', as: :items_catalog
  get       'items/editform/:id'=> 'items#editform'
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

  get       'checkouts/review'         => 'checkouts#review', as: :checkout_review
  resources :checkout_items, only: [:create, :update, :destroy]

  get       'cart'              => 'checkouts#show', as: :cart
  get       'cart/checkout'     => 'checkouts#checkout_begin', as: :checkout_begin
  patch     'cart/checkout'     => 'checkouts#checkout_end', as: :checkout_end

end