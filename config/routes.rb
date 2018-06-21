Rails.application.routes.draw do

  get 'checkout_items/create'
  get 'checkout_items/update'
  get 'checkout_items/destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get       '/'                 => 'pages#home'


  get       'items/manage'      => 'items#manage'     , as: :items_manage

  resources :items

  get       'items'             => 'items#index'
  get       'items/new'         => 'items#new'
  post      'items'             => 'items#create'
  get       'items/:id'         => 'items#show'
  get       'items/:id/edit'    => 'items#edit'       , as: :edit_destination
  patch     'items/:id'         => 'items#update'
  delete    'items/:id'         => 'items#destroy'


  resources :users
  get       'signup'            => 'users#new'
  get       'login'             => 'sessions#new'
  post      'login'             => 'sessions#create'
  delete    'logout'            => 'sessions#destroy'


  resources :checkout, :checkout_items
  get       'checkouts'         => 'checkouts#index'
  get       'cart'              => 'carts#show'

end
