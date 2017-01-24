source 'https://rubygems.org'
ruby '2.3.3'

###################
## Rails General ##
###################

gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jbuilder', '~> 2.5'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#####################
## Splice Specific ##
#####################

gem 'slim-rails'          # clean emmett-like html templates
gem 'font-awesome-rails'  # icon sets
gem 'sorcery'             # Authentication
gem 'pundit'              # Authorization

################
## Deployment ##
################

gem 'capistrano', '~> 3.7.1'
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano-passenger'

##########################
## Environment Specific ##
##########################

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'i18n-tasks'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
end

group :development do
  ######################
  ## Web Page Helpers ##
  ######################
  gem 'binding_of_caller'   # Dependancy for better_errors
  gem 'better_errors'       # Pretty up error pages'
  gem 'letter_opener'       # View emails in development w/o sending
  ###########
  ## Other ##
  ###########
  gem 'ruby-graphviz'
  gem 'rails-erd'
  # gem 'rails_real_favicon' # FavIcon Generator (not needed unless regenerating favicons)
  ###################
  ## Rails Default ##
  ###################
  gem 'listen', '~> 3.0.5'
  gem 'web-console'         # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'spring'              # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
end
