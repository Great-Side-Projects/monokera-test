Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # API routes
  namespace :api do
    namespace :v1 do
      # ruta POST /api/v1/orders
      resources :orders, only: [:create]

      # Esto crea una ruta anidada para obtener los pedidos de un cliente
      # GET /api/v1/customers/:customer_id/orders
      resources :customers, only: [] do # No necesitamos rutas para /customers solos
        resources :orders, only: [:index] # Pero sí para sus pedidos
      end
    end
  end

end
