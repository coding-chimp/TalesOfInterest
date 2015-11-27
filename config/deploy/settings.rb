# -*- encoding : utf-8 -*-
set :application, 'talesofinterest.de'

set :repo_url, 'git@github.com:coding-chimp/TalesOfInterest.git'
set :branch,   'master'

set :user, "#{fetch(:application)}"

set :deploy_to, "/data/#{fetch(:application)}"
set :keep_releases, 2

set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  database.example.yml
  log_rotation
  monit
  nginx.conf
  secrets.yml
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: 'nginx.conf',
    link: "/opt/nginx/conf/sites-enabled/{{full_app_name}}"
  },
  {
    source: 'unicorn_init.sh',
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: 'log_rotation',
    link: "/etc/logrotate.d/{{full_app_name}}"
  },
  {
    source: 'monit',
    link: "/etc/monit/conf.d/{{full_app_name}}.conf"
  }
])
