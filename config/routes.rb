TalesOfInterest::Application.routes.draw do
  break if ARGV.join.include? 'assets:precompile'
  
  get 'sitemap', to: 'sitemap#index'

  get    'admin/blogroll',          to: 'blogrolls#index',  as: :blogrolls
  post   'admin/blogroll',          to: 'blogrolls#create'
  get    'admin/blogroll/new',      to: 'blogrolls#new',    as: :new_blogroll_item
  get    'admin/blogroll/:id/edit', to: 'blogrolls#edit',   as: :edit_blogroll_item
  get    'admin/blogroll/:id',      to: 'blogrolls#show',   as: :blogroll
  put    'admin/blogroll/:id',      to: 'blogrolls#update'
  delete 'admin/blogroll/:id',      to: 'blogrolls#destroy'

  get    'admin/pages',             to: 'pages#index',      as: :pages
  post   'admin/pages',             to: 'pages#create'
  get    'admin/pages/new',         to: 'pages#new',        as: :new_page
  get    'admin/pages/:id/edit',    to: 'pages#edit',       as: :edit_page
  get    ':id',                     to: 'pages#show',       as: :page,
         :constraints => lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }
  put    ':id',                     to: 'pages#update',
         :constraints => lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }
  delete ':id',         to: 'pages#destroy',
         :constraints => lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "episodes#index"

  get "/:id" => "podcasts#show",
                :constraints => lambda { |r| Podcast.find_by_name(r.params[:id].capitalize).present? },
                :as => :podcast

  get "/:id(/page/:page)", :controller => 'podcasts', :action => 'show'

  get "/:id/feed" => "podcasts#feed", :as => :podcast_feed, :defaults => { :format => 'rss' } 

  get "/" => "episodes#index", :as => :episodes

  get "/(page/:page)", :controller => 'episodes', :action => 'index'

  get ":podcast/latest" => "episodes#latest", :as => :latest

  get ":podcast/:id" => "episodes#show", :as => :episode

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
