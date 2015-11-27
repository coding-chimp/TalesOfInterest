# -*- encoding : utf-8 -*-
set :stage, :production

server 'as3.netflower.de', user: 'talesofinterest.de', roles: %w{web app}

set :server_name, 'talesofinterest.de www.talesofinterest.de'

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
