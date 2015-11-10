Rails.application.routes.draw do


  root :to => 'onboards#index'
  mount ShopifyApp::Engine, at: '/'
  mount Resque::Server, :at => "/resque"

  get '/customer/archive/:id' => 'customers#archive', as: :customer_archive
  get '/customer/unarchive/:id' => 'customers#unarchive', as: :customer_unarchive
  
  resources :customers, :only=> [:index, :show, :new, :create, :destroy]
  resource :shop, :only=> [:edit, :update]
  get '/shop/plan' => 'shops#plan', as: :plan
  get '/shop/plans/update_plan_step_2' => 'shops#update_plan_step_2', as: :update_plan_step_2
  patch '/shop/plans/update_plan_step_1' => 'shops#update_plan_step_1', as: :update_plan_step_1
  post '/customer/bulk_scan' => 'customers#bulk_scan', as: :bulk_scan

  get '/welcome' => 'onboards#index', as: :welcome
  get '/welcome/scan' => 'onboards#scan', as: :welcome_scan
  get '/welcome/result' => 'onboards#result', as: :onboard_result

  scope '/hooks', :controller => :hooks do
    post :new_customer_callback
    post :app_uninstalled_callback
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
