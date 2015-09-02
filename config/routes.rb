Rails40Starter::Application.routes.draw do
  resources :points

  resources :cmdqueries

  resources :channels

  resources :devices

  resources :groups

  namespace :cpanel do
    resources :site_configs
  end

  devise_for :users

  scope '/user' do
    get '/profile' => 'front#profile', as: :front_profile
    get '/device/new' => 'front#new_device', as: :front_new_device
    get '/channel/new' => 'front#new_channel', as: :front_new_channel
    get '/charts/show' => 'front#show_chart', as: :front_show_chart

    get '/device/:id' => 'front#show_device', as: :front_show_device
    get '/device/:id/edit' => 'front#edit_device', as: :front_edit_device
    get '/device/:id/charts' => 'front#show_chart', as: :front_device_chart
    get '/device/:id/channel/:cid/chart' => 'front#show_channel_chart', as: :front_device_channel_chart

    get '/device/:device_id/channel/new' => 'front#new_channel', as: :front_device_new_channel
    get '/device/:device_id/channel/:channel_id/edit' => 'front#edit_channel', as: :front_device_edit_channel
    post '/device/:device_id/channel/:channel_id/get_cmdquery' => 'front#get_cmdquery', as: :front_cmdquery_get
  end

  scope '/user', module: 'cpanel' do
    get '/' => 'front#index'
    #resources :cmdqueries, only: [:new, :create]
    get '/device/:id/:cid/cmdqueries/new' => 'cmdqueries#new', as: :new_cpanel_cmdquery
    post '/cmdqueries' => 'cmdqueries#create', as: :cpanel_cmdqueries
    get '/cmdqueries/index' => 'cmdqueries#index'
  end

  get '/info' => 'front#get_info'
  #post '/iotdev/v1.0/devices' => 'devices#webCreate', as: :devices_webCreate
  get '/iotdev/v1.0/device' => 'devices#getDevice', as: :devices_getDevice
  get '/iotdev/v1.0/channel' => 'devices#getChannel', as: :devices_getChannel
  post '/iotdev/v1.0/datapoints' => 'devices#postDatapoint', as: :devices_postDatapoint

  get '/iotdev/v1.0/devices/list' => 'devices#index', as: :devices_list
  #get '/iotdev/v1.0/send' => 'devices#channel', as: :devices_channel
  # get '/iotdev/v1.0/send' => 'channels#send_data', as: :channel_send_data
  # get '/iotdev/v1.0/send' => 'channels#receive_data', as: :channel_send_data
  # get '/iotdev/v1.0/datetime' => 'devices#datetime', as: :devices_datetime

  scope '/data' do 
    get '/getDatapoints/:cid' => 'front#get_channel_data', as: :front_get_channel_data
    # 5571a1c15530313648010000 '/data/getDatapoints/5571a1c15530313648010000?seq_num=000'
  end

  scope 'iotdev/v1.0', module: 'apiv10' do
    get 'cmdquery' => 'apibase#cmdquery', as: :apibase_cmdquery
    get 'datetime' => 'apibase#datetime', as: :apibase_datetime
    get 'send' => 'apibase#receive_data', as: :apibase_receive_data
    # post 'cmdquery_get' => 'apibase#cmdquery_get', as: :apibase_cmdquery_get
  end

  # post '/post_info' => 'front#post_info', as: :front_post_info
  get '/admin' => 'front#admin', as: :front_admin
  get '/sdk/android' => 'front#sdk', as: :front_sdk
  
  root 'front#index'

  namespace 'apiv00' do
    get 'front/index'
    get 'front/test01'
    get 'front/test_data'
  end

  namespace 'mobile' do
    get '/sayhello' => 'front#index'
    get '/datetime' => 'front#datetime'
    post '/users' => 'front#create_user'
    get '/signin' => 'front#signin_user'
  end

  # scope 'front/test', module: 'apiv10test' do
  #   get 'stock_chart' => ''
  # end
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
