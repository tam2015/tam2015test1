Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  # Rota para os assets armazenados no Gridfs
  get "/storage/*path" => "gridfs#serve"

  ### Refatore this  ###
  # get "orders_without_address", to: "reports#orders_without_address", as: :orders_without_address
  # get "feedback/new", to: "feedbacks#new", as: :feedback_new
  # post "feedback/new", to: "feedbacks#create", as: :feedback_create
  post "/payment_notifications/create", to: "payment_notifications#create", as: :create_notification

  resources :plans        , only: [ :index ]

  providers = Regexp.union Webhook.providers
  post "webhook/:provider",
    constraints: { provider: providers },
    to: "webhook#provider"

  devise_scope :user do
     get "profile"      => "users#show"             , as: :profile
     get "profile_plan" => "users#user_profile_plan", as: :user_profile_plan
     get "seller_feedback_message" => "users#seller_feedback_message", as: :seller_feedback_message
     get "edit_seller_feedback_message" => "users#edit_seller_feedback_message", as: :edit_seller_feedback_message
     post "update_seller_feedback_message" => "users#update_seller_feedback_message", as: :update_seller_feedback_message
    # post "edit_avatar"=> "users#edit_avatar"
    #get   "register"  => "registrations#new"
    #get   "invite"    => "registrations#new_invite"
    #post  "invite"    => "registrations#create_user_from_invitation", as: :invitation
  end

  devise_for :users,
    path: "",
    controllers: {
      passwords: 'passwords',
      invitations: 'invitations',
      sessions: 'sessions',
      omniauth_callbacks: 'omniauth_callbacks' },
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      # sign_up: 'sign_up',
      # account_update: 'password_update',
      # password: 'secret',
      invitation: 'invites',
      # confirmation: 'verification',
      # registration: 'register'
      }

  # Resources
  as :user do
    resources :invitations, path: :invites, only: [ :index ] do
      collection do
        get "import"# => :import_invitation
      end
    end

    resources :users, path: "u", only: [ :index, :show, :edit, :update ]

    # Payments
    resources :payment_notifications
    resources :subscriptions, only: [:edit, :update] do
      get "/checkout" => "subscriptions#checkout", on: :collection
    end

    resources :dashboards, path: "d" do
      # get "/feedbacks"   => "feedbacks#index"

      resources :aircrm_preferences

      get "/reload"     => "dashboards#reload"
      get "/search"     => "dashboards#search"

      resources :customers

      # Mercadolibre
      scope module: 'mercadolibre' do
        resources :label
        get "/mass_receipts", to: "receipts#mass_receipt"
        get "meli_label", to: "label#meli_label"
        get "multiple_meli_labels", to: "label#multiple_meli_labels"

        get "monitor", to: "monitor#monitor", on: :collection
        get "monitor_from_categories", to: "monitor#monitor_from_categories", on: :collection

        resources :categories, only: [ :index, :show ] do
          # On collection
          get "suggest", on: :collection
        end

        resources :storages do
          get "edit", to: "storages#edit", on: :collection
          put "update", to: "storages#update", on: :collection
          collection do
            get :catalog_import
            post :import
            get "/catalog", to: "storages#catalog"
            get "/stores_per_item", to: "storages#stores_per_item"
          end
        end

        resources :items do
          member do
            get "publish"
            get "meli_update"


          resources :pictures, only: [:index, :new, :create, :destroy]
          end

          collection do
            get "refresh"
            get :catalog_import
            post :import
            get "/catalogo_franquiador", to: "items#catalogo_franquiador"
          end
        end
        get "/trends"     => "trends#main"
        get "/trends/by_category"=> "trends#by_category"
      end


      scope module: 'mercadolibre' do
        resources :questions, only: [ :index, :edit, :update, :destroy ]
        post "/:dashboard_id/questions/:question_id", to: "questions#block_customer",  on: :collection, as: :block_customer
        post "/:dashboard_id/questions/:question_id/unblock_customer", to: "questions#unblock_customer",  on: :collection, as: :unblock_customer
        get "/feedbacks"   => "feedbacks#index"
      end

      resources :steps, path: "s", except: [] do
        post "sort" # SORT BOXES

        collection do
          post "sort" # SORT STEPS
        end
      end

      resources :boxes, path: "b" , only: [:index]
      get "index_test", to: "boxes#index_test"
      resources :boxes, path: "" , except: [:index] do
          scope module: 'mercadolibre' do
            # HACK: it runs a lot of standards and best practices
            # USE: resources :feedbacks, only: [ :show, :new, :create, :edit, :update ]
            get '/feedback', to: "feedbacks#show"
            get "feedback/new", to: "feedbacks#new", as: :feedback_new, on: :collection
            post "feedback/new", to: "feedbacks#create", as: :feedback_create, on: :collection
            get "feedback/edit", to: "feedbacks#edit", as: :feedback_edit, on: :collection
            patch "feedback/edit", to: "feedbacks#update", as: :feedback_update, on: :collection
            get "feedback/edit_reason", to: "feedbacks#edit_reason", as: :feedback_edit_reason, on: :collection
            patch "feedback/edit_reason", to: "feedbacks#update_reason", as: :feedback_update_reason, on: :collection
            post "feedback/notify", to: "feedbacks#notify", on: :collection

            resources :receipts
          end
        end
        post "status"
    end

    # Specific to User
    get "/d" => "dashboard#index", as: :user_root
  end

  # Shipping
  scope module: 'mercadolibre' do
    resources :shippings, only: [:edit, :update] do
      get ":token/receiver" => "shippings#receiver", on: :collection, as: :receiver
      post "notify"
      post "status"
      patch "update_status", to: "shippings#update_status"
    end
    resources :payments, only: [:edit, :update]
  end

  # Pages
  get "/home"     , to: "home#index"
  get "/about"    , to: "home#about"
  get "/services" , to: "home#services"
  get "/contact"  , to: "home#contact"
  get "/jobs"  , to: "home#jobs"
  get "/terms"  , to: "home#terms"
  get "/guide"  , to: "home#guide"

  authenticate :user, lambda { |u| u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  get '*unmatched_route', :to => 'application#raise_not_found!'
  root "home#index"
end
