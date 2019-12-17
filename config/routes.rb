Rails.application.routes.draw do

  # Knock with JWT
  post 'user_token' => 'user_token#create'
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :users, only: [:show]
  end

  # devise for rails web application access
  devise_for :users
  devise_scope :user do
     get 'login',  to: 'devise/sessions#new'
     get 'logout', to: 'devise/sessions#destroy'
  end

  # *********************************************************************************
  # CLIENTS
  # For Rails
  resources :clients, only: [:index] do
    get  'utilities', on: :collection
    post 'import',    on: :collection
  end
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :clients, only: [:index] do
    end
  end 

  # *********************************************************************************
  # COMPANIES
  # For Rails
  resources :companies, only: [:index]
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :companies, only: [:index]
  end 

  # *********************************************************************************
  # COUNTRIES
  # For Rails
  resources :countries, only: [:index]
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :countries, only: [:index]
  end 

  # *********************************************************************************
  # ENTITIES
  # For Rails
  #resources :entities, only: [:index] do
  #  get  'utilities', on: :collection
  #  post 'import',    on: :collection
  #end
  # For APIs
  #scope '/api/v1', module: 'api/v1' do
  #  resources :entities, only: [:index, :show]
  #end 

  # *********************************************************************************
  # EVENTS
  # For Rails
  resources :events, only: [] do
    get  'utilities', on: :collection
    post 'import',    on: :collection
  end
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :events, only: [:index] do
    end
    #get '/events/:account_id', to: "events#index"
  end 

  # *********************************************************************************
  # MENUES
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :menues, only: [:index]
  end 
  
  # *********************************************************************************
  # ORDERS
  # For Rails
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :orders, only: [:index, :show] do
      #get  'lastorder/:company_id', on: :collection, action: :get_last_order  
      get  'grid', on: :collection, action: :get_orders_grid
      # Order Events
      resources :order_events, only: [:create, :index] do
        get  'last_event/:scope', on: :collection, action: :get_last_event
      end
      # Order Items
      resources :items, only: [:create, :index]
    end
  end 

  # *********************************************************************************
  # STOCK ITEMS
  # For Rails
  #resources :items, only: [] do
  #  get  'utilities', on: :collection
  #  post 'import',    on: :collection
  #end
  # For APIs
  #scope '/api/v1', module: 'api/v1' do
  #  resources :items, only: [:index]
  #end 

  # *********************************************************************************
  # TRACKING MILESTONE
  # For Rails
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :tracking_milestones, only: [:index]
  end 

  # *********************************************************************************
  # WAREHOUSE
  # For Rails
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :warehouses, only: [:index]
  end 

  # *********************************************************************************
  # WAREHOUSE RECEIPT
  # For Rails
  resources :warehouse_receipts, only: [:index] do
    get  'utilities', on: :collection
    post 'import',    on: :collection
  end
  # resources :warehouse_receipts, only: [:index]
  # For APIs
  scope '/api/v1', module: 'api/v1' do
    resources :warehouse_receipts, only: [:create, :update]
  end 

  # *********************************************************************************
  # Utilities routes
  # as
  #    Download files: /download/log/<filename>.<ext>
  #                    => ApplicationController#download
  #                    PARAMS: {
  #                             "controller" => "application",
  #                             "action" => "download",
  #                             "type" => "log",
  #                             "id" => <filename>,
  #                             "format" => <ext>    // ej. "log"
  #                            }
  match 'download/:type/:id' => 'application#download', :via => [:get]

  # -------------------------------------------------------------------------------------
  # MAIN ROOT
  root to: 'rails/welcome#index'
end
