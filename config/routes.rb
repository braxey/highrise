Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Landing page.
  root "pages#home"

  # Dashboards.
  get "dashboard", to: "pages#dashboard"

  # Auth routes.
  get "login", to: "sessions#new", as: :new_session
  resource :session, except: %i[new]
  resources :passwords, param: :token

  # Registration / Account management.
  get "signup", to: "users#new", as: :new_user
  resource :users, only: %i[create]

  # Roles.
  resources :roles

  # Organizations.
  resources :organizations do
    # Manage users within organizations.
    resources :organization_memberships, except: %i[edit update]
  end
end
