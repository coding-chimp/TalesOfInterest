source 'https://rubygems.org'

gem 'rails', '3.2.22'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  # Layout
  gem 'therubyracer'
  gem 'compass-rails'
  gem 'zurb-foundation'
  gem 'font-awesome-rails'

  # DataTables
  gem 'jquery-ui-rails'
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
end

group :development do
  gem 'rails-erd'
  gem 'bullet'
  gem 'rack-mini-profiler'
end

gem 'jquery-rails'

# Users
gem 'devise'

# Search
gem 'ransack'

# Pretty URLs
gem 'friendly_id'

# Markdown formatting
gem 'redcarpet'
gem 'html2markdown', github: 'coding-chimp/html2markdown'

# Pretty Terminal output
gem 'hirb'

# Attach files
gem "paperclip", "~> 3.0"

# Pagination
gem 'kaminari'

# XML Parser
gem 'nokogiri'

# Easier forms
gem 'simple_form'

# Memcached
gem 'dalli'

# Web Player
gem 'podlove-web-player-rails'

# Faster site loading
gem 'turbolinks'
gem 'jquery-turbolinks'

# Makes the show notes sortable
gem 'acts_as_list'

# App server
gem 'unicorn'

# Cron jobs
gem 'whenever', require: false

# Digest access authentication for qloudstat
gem 'net-http-digest_auth'

group :deployment, :development, :test do
  gem 'capistrano',  '~> 3.2.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
end

gem 'newrelic_rpm'
gem 'mixpanel-ruby'
gem 'test-unit', '~> 3.0'
