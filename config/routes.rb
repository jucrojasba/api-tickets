Rails.application.routes.draw do
  # optional rout for the moment attached to changes

  get "events/:event_id/tickets/summary", to: "tickets#summary"
  get "events/:event_id/tickets/:quantity", to: "tickets#reserve_tickets", defaults: { format: :json }


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :tickets do
    collection do
      get :summary
    end
    get :logs, on: :member # Esto genera la ruta GET /tickets/:ticket_id/logs
  end

  patch "tickets/:ticket_id/status", to: "tickets#update_status"

  post "events/:event_id/tickets", to: "tickets#create"
end
