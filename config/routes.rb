Rails.application.routes.draw do

  devise_for :users

  get 'configuraciones/check_empresa_nombre' => 'configuraciones#check_empresa_nombre'
  resources :configuraciones, only: [:index, :edit, :update]

  get 'proveedores/check_nombre' => 'proveedores#check_nombre'
  resources :proveedores

  get 'empleados/check_nombre' => 'empleados#check_nombre'
  resources :empleados

  get 'categorias/check_nombre' => 'categorias#check_nombre'
  resources :categorias

  get 'mercaderias/check_codigo' => 'mercaderias#check_codigo'
  get 'mercaderias/buscar' => 'mercaderias#buscar'
  resources :mercaderias

  resources :inventarios, only: [:index]

  resources :movimiento_mercaderias
  
  get 'monedas/check_nombre' => 'monedas#check_nombre'
  resources :monedas

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
