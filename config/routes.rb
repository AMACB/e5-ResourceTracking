Rails.application.routes.draw do

  get       '/'                 => 'pages#home'
  get       'info'              => 'pages#info'

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
  get       'signup'            => 'users#new', as: :signup
  get       'login'             => 'sessions#new', as: :login
  post      'login'             => 'sessions#create'
  delete    'logout'            => 'sessions#destroy'
  post      'email_resend'      => 'users#email_resend', as: :email_resend
  get       'confirm_email'     => 'users#confirm_email', as: :confirm_email
  get       'profile'           => 'users#show', as: :profile


  get       'requests/review'       => 'requests#review', as: :request_review
  post      'requests/approve/:id'  => 'requests#approve', as: :request_approve
  post      'requests/reject/:id'   => 'requests#reject', as: :request_reject
  get       'requests'              => 'requests#index', as: :requests
  get       'check_in'              => 'requests#check_in_all', as: :check_in_all
  get       'check_out'             => 'requests#check_out_all', as: :check_out_all
  get       'check_in/:id'          => 'requests#check_in', as: :check_in
  get       'check_out/:id'         => 'requests#check_out', as: :check_out
  post      'check_in/:id'          => 'requests#check_in_final', as: :check_in_final
  post      'check_out/:id'         => 'requests#check_out_final', as: :check_out_final
  post      'request_items'         => 'request_items#create', as: :request_items_create
  patch     'request_items/:id'     => 'request_items#update', as: :request_items_update
  put       'request_items/:id'     => 'request_items#update', as: :request_items_update2
  delete    'request_items/:id'     => 'request_items#destroy', as: :request_items_destroy

  get       'cart'              => 'requests#show', as: :cart
  patch     'cart'              => 'requests#update', as: :cart_update
  get       'cart/checkout'     => 'requests#checkout_begin', as: :checkout_begin
  patch     'cart/checkout'     => 'requests#checkout_end', as: :checkout_end

  get       'notifications'           => 'notifications#index', as: :notifications
  post      'notifications/read/:id'  => 'notifications#read', as: :notifications_read

end