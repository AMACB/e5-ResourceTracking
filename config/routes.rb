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
  get       'confirm_email'     => 'users#confirm_email', as: :confirm_email
  get       'profile'           => 'users#show', as: :profile


  resources :checkout

  get       'checkouts/review'  => 'checkouts#review', as: :checkout_review
  post      'checkout_items'    => 'checkout_items#create', as: :checkout_items_create
  patch     'checkout_items/:id'=> 'checkout_items#update', as: :checkout_items_update
  put       'checkout_items/:id'=> 'checkout_items#update', as: :checkout_items_update2
  delete    'checkout_items/:id'=> 'checkout_items#destroy', as: :checkout_items_destroy

  get       'cart'              => 'checkouts#show', as: :cart
  get       'cart/checkout'     => 'checkouts#checkout_begin', as: :checkout_begin
  patch     'cart/checkout'     => 'checkouts#checkout_end', as: :checkout_end

end