Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'

  # sidekiq web UI
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets.sidekiq_username &&
      password == Rails.application.secrets.sidekiq_password
  end
  mount Sidekiq::Web, at: '/sidekiq'
end

Spree::Core::Engine.append_routes do
  scope '(:locale)', locale: /#{Spree.available_locales.join('|')}/, defaults: { locale: nil } do
    root to: 'home#index'

    resources :products, only: [:index, :show], path: '/products'
    resources :vendors, only: [:show], path: '/vendors'

    get '/categories', to: 'taxons#index', as: :categories
    get '/products/:id/related', to: 'products#related'
    # route globbing for pretty nested taxon and product paths
    get '/t/*id', to: 'taxons#show', as: :nested_taxons
    get '/product_carousel/:id', to: 'taxons#product_carousel'

    # non-restful checkout stuff
    patch '/checkout/update/:state', to: 'checkout#update', as: :update_checkout
    get '/checkout/:state', to: 'checkout#edit', as: :checkout_state
    get '/checkout', to: 'checkout#edit', as: :checkout

    resources :orders, except: [:index, :new, :create, :destroy]

    resources :addresses, except: [:index, :show]

    get '/cart', to: 'orders#edit', as: :cart
    patch '/cart', to: 'orders#update', as: :update_cart
    put '/cart/empty', to: 'orders#empty', as: :empty_cart

    get '/content/cvv', to: 'content#cvv', as: :cvv
    get '/content/test', to: 'content#test'
    get '/cart_link', to: 'store#cart_link', as: :cart_link
    get '/account_link', to: 'store#account_link', as: :account_link

    get '/shops/search', to: 'shops#search', as: :search_shops
    get '/shops/:slug', to: 'shops#show', as: :shop

    get '/locales', to: 'locale#index', as: :locales
    get '/locale/set', to: 'locale#set', as: :set_locale
    get '/currency/set', to: 'currency#set', as: :set_currency
    get '/country/set', to: 'country#set', as: :set_country

    get '/api_tokens', to: 'store#api_tokens'
    post '/ensure_cart', to: 'store#ensure_cart'

    get '/pages/:slug', to: 'cms_pages#show', as: :page

    get '/404', to: 'errors#not_found'
    get '/500', to: 'errors#internal_server'
    get '/422', to: 'errors#unprocessable'
    get '/forbidden', to: 'errors#forbidden', as: :forbidden
    get '/unauthorized', to: 'errors#unauthorized', as: :unauthorized


    get '/sell', to: 'shops#index', as: :sell
    get '/people/:slug', to: 'users#show', as: :user_profile

    get '/your/account', to: 'profile#show', as: :user_account
    get '/your/profile', to: 'profile#edit', as: :edit_user_profile
    get '/your/profile/preferences', to: 'profile#preferences', as: :user_preferences
    put '/your/profile/preferences', to: 'profile#update_preferences', as: :update_user_preferences
    get '/your/profile/addresses', to: 'profile#addresses', as: :user_addresses
    get '/your/profile/orders', to: 'profile#orders', as: :user_orders

    post '/your/shops/:slug/onboarding/create_products', to: 'shops#create_product', as: :create_product
    get '/your/shops/:slug/onboarding/products/:product_slug', to: 'shops#edit_product', as: :edit_product_onboarding

    put '/profile_picture', to: 'users#update_profile_picture', as: :profile_picture
    get '/your/orders/:id', to: 'orders#show', as: :your_order
    get '/your/orders', to: 'orders#index', as: :your_orders
    get '/your/shops/onboarding', to: 'shops#onboarding', as: :onboarding
    get '/your/shops/:slug/onboarding/:screen_type', to: 'shops#onboarding_update', as: :shop_onboarding
    get '/your/shops/:slug/onboarding', to: 'shops#onboarding', as: :welcome_onboarding
    get '/your/shops/:slug', to: 'shops#show', as: :your_shop
    put '/your/shops/:slug', to: 'shops#update', as: :update_shop
    post '/your/shops', to: 'shops#create', as: :create_shop
    get '/help', to: 'static_pages#help', as: :help
    get '/about', to: 'static_pages#about', as: :about
    get '/affiliates', to: 'static_pages#affiliates', as: :affiliates
  end
end
