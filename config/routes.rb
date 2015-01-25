Rails40Starter::Application.routes.draw do
  resources :devices

  resources :groups

  namespace :cpanel do
    resources :site_configs
  end

  devise_for :users

  get '/info' => 'front#get_info'
  #post '/iotdev/v1.0/devices' => 'devices#webCreate', as: :devices_webCreate
  get '/iotdev/v1.0/device' => 'devices#getDevice', as: :devices_getDevice
  get '/iotdev/v1.0/channel' => 'devices#getChannel', as: :devices_getChannel
  post '/iotdev/v1.0/datapoints' => 'devices#postDatapoint', as: :devices_postDatapoint

  get '/iotdev/v1.0/devices/list' => 'devices#index', as: :devices_list
  get '/iotdev/v1.0/datetime' => 'devices#datetime', as: :devices_datetime

  # post '/post_info' => 'front#post_info', as: :front_post_info
  
  root 'front#index'
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
