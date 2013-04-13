TalesOfInterest::Application.routes.draw do
  break if ARGV.join.include? 'assets:precompile'

  as :user do
    get "/login" => "sessions#new"
  end
  
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }, 
             :controllers => { sessions: 'sessions' }

  get    'sitemap',                     to: 'sitemap#index'

  get    'admin/blogroll',              to: 'blogrolls#index',        as: :blogrolls
  post   'admin/blogroll',              to: 'blogrolls#create'
  get    'admin/blogroll/new',          to: 'blogrolls#new',          as: :new_blogroll_item
  get    'admin/blogroll/:id/edit',     to: 'blogrolls#edit',         as: :edit_blogroll_item
  get    'admin/blogroll/:id',          to: 'blogrolls#show',         as: :blogroll
  put    'admin/blogroll/:id',          to: 'blogrolls#update'
  delete 'admin/blogroll/:id',          to: 'blogrolls#destroy'

  get    'admin/pages',                 to: 'pages#index',            as: :pages
  post   'admin/pages',                 to: 'pages#create'
  get    'admin/pages/new',             to: 'pages#new',              as: :new_page
  get    'admin/pages/import',          to: 'pages#import_form',      as: :import_page
  post   'admin/pages/import',          to: 'pages#import_xml'
  get    'admin/pages/:id/edit',        to: 'pages#edit',             as: :edit_page
  get    ':id',                         to: 'pages#show',             as: :page,
         constraints: lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }
  put    ':id',                         to: 'pages#update',
         constraints: lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }
  delete ':id',                         to: 'pages#destroy',
         constraints: lambda { |r| Page.find_by_titel(r.params[:id].capitalize).present? }

  get    'admin/podcasts',              to: 'podcasts#index',         as: :podcasts
  post   'admin/podcasts',              to: 'podcasts#create'
  get    'admin/podcasts/new',          to: 'podcasts#new',           as: :new_podcast
  get    'admin/podcasts/import',       to: 'podcasts#import_form',   as: :import_podcast
  post   'admin/podcasts/import',       to: 'podcasts#import_xml'
  get    'admin/podcasts/:id/edit',     to: 'podcasts#edit',          as: :edit_podcast
  get    '/:id/feed',                   to: 'podcasts#feed',          as: :podcast_feed,
         defaults: { format: 'rss' }
  get    ':id',                         to: 'podcasts#show',          as: :podcast,
         constraints: lambda { |r| Podcast.find_by_name(r.params[:id].capitalize).present? }
  get    ':id(/page/:page)',            to: 'podcasts#show'
  put    ':id',                         to: 'podcasts#update',
         constraints: lambda { |r| Podcast.find_by_name(r.params[:id].capitalize).present? }
  delete ':id',                         to: 'podcasts#destroy',
         constraints: lambda { |r| Podcast.find_by_name(r.params[:id].capitalize).present? }

  get    '/',                           to: 'episodes#index',         as: :episodes
  post   '/',                           to: 'episodes#create'
  get    '/(page/:page)',               to: 'episodes#index'
  get    ':podcast/:id',                to: 'episodes#show',          as: :episode,
         constraints: lambda { |r| Podcast.find_by_name(r.params[:podcast].capitalize).present? }
  put    'podcasts/:podcast/:id',       to: 'episodes#update'
  delete ':podcast/:id',                to: 'episodes#destroy',
         constraints: lambda { |r| Podcast.find_by_name(r.params[:podcast].capitalize).present? }
  get    ':podcast/latest',             to: 'episodes#latest'
  get    'admin/:podcast/episodes',     to: 'episodes#podcast_index', as: :podcast_episodes
  get    'admin/:podcast/episodes/new', to: 'episodes#new',           as: :new_podcast_episode
  get    'admin/:podcast/:id/edit',     to: 'episodes#edit',          as: :edit_episode

  root to: 'episodes#index'

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
