Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".

  mount Spree::Core::Engine, at: '/'

  # sidekiq web UI
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets.sidekiq_username &&
      password == Rails.application.secrets.sidekiq_password
  end
  mount Sidekiq::Web, at: '/sidekiq'

  Spree::Core::Engine.add_routes do
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

      resources :orders, except: [:index, :new, :create, :destroy, :show]

      resources :addresses, except: [:index, :show]

      get '/cart', to: 'orders#edit', as: :cart
      patch '/cart', to: 'orders#update', as: :update_cart
      put '/cart/empty', to: 'orders#empty', as: :empty_cart

      get '/content/cvv', to: 'content#cvv', as: :cvv
      get '/content/test', to: 'content#test'
      get '/cart_link', to: 'store#cart_link', as: :cart_link
      get '/account_link', to: 'store#account_link', as: :account_link
      get '/shops/:slug', to: 'shops#show', as: :shop

      get '/locales', to: 'locale#index', as: :locales
      get '/locale/set', to: 'locale#set', as: :set_locale
      get '/currency/set', to: 'currency#set', as: :set_currency

      get '/api_tokens', to: 'store#api_tokens'
      post '/ensure_cart', to: 'store#ensure_cart'

      get '/pages/:slug', to: 'cms_pages#show', as: :page

      get '/forbidden', to: 'errors#forbidden', as: :forbidden
      get '/unauthorized', to: 'errors#unauthorized', as: :unauthorized


      get '/sell', to: 'shops#index', as: :sell
      get '/your/orders/:id', to: 'orders#show', as: :your_order
      get '/your/orders', to: 'orders#index', as: :your_orders
      get '/your/shops/:slug/onboarding/screener/:screen_type', to: 'shops#welcome_screener', as: :welcome_screener
      get '/your/shops/:slug/onboarding', to: 'shops#onboarding', as: :onboarding
      get '/your/shops/:slug', to: 'shops#show', as: :your_shop
      get 'search/shops', to: 'shops#search', as: :search_shops
    end
  end
end
