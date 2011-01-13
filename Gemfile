source 'http://gemcutter.org'

gem 'rails',          '3.0.3'   # Duh...
gem 'mysql2',         '0.2.6'   # MySQL...
gem 'configatron',    '2.6.4'   # Storing config options
gem 'paperclip',      '2.3.6'   # Image resize
gem 'haml',           '3.0.18'  # HTML prototyping
gem 'jquery-rails',   '0.2.3'   # Add jQuery to Rails
gem 'oauth',          '0.4.4'   # oAuth connect
gem 'twitter',        '1.1.0'   # Connections to Twitter


# DEVELOPMENT
group :development do
  gem 'capistrano',       '2.5.19'  # Cap is only run in dev on local side...
  gem 'cap-recipes',      '0.3.36'
  gem 'capistrano-ext',   '1.2.1'
  gem 'mongrel',          '1.2.0.pre2'

  gem 'rspec-rails',      '2.0.0'   # BDD
  gem 'annotate',         '2.4.0'   # Pretty details in models
end

# PRODUCTION
group :production do
  gem 'memcache-client',  '1.8.5'
  gem 'passenger',        '2.2.15'
end
