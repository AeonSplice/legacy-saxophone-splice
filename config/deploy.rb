# config valid only for Capistrano 3.7
lock '3.7'

set :application, 'aeonsplice'
set :repo_url, 'git@github.com:aeonsplice/saxophone-splice.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/aeonsplice.com'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Prevent capistrano from generating bin stubs when running bundle install
set :bundle_binstubs, nil

# Tell passenger what version of ruby via RVM to use
set :passenger_rvm_ruby_version, '2.3.3'
set :rvm_ruby_version, '2.3.3'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

##################
## Lets Encrypt ##
##################

# Set the roles where the let's encrypt process should be started
# Be sure at least one server has primary: true
# default value: :web
# set :lets_encrypt_roles, :lets_encrypt

# Optionally set the user to use when installing on the remote system
# default value: nil
# set :lets_encrypt_user, nil

# Set it to true to use let's encrypt staging servers
# default value: false
# set :lets_encrypt_test, true

# Set your let's encrypt account email (required)
# The account will be created if no private key match
# default value: nil
set :lets_encrypt_email, 'admin@aeonsplice.com'

# Set the path to your let's encrypt account private key
# default value: "#{fetch(:lets_encrypt_email)}.account_key.pem"
set :lets_encrypt_account_key, "#{fetch(:lets_encrypt_email)}.account_key.pem"

# Set the domains you want to register (required)
# This must be a string of one or more domains separated a space - e.g. "example.com example2.com"
# default value: nil
set :lets_encrypt_domains, 'aeonsplice.com www.aeonsplice.com'

# Set the path from where you are serving your static assets
# default value: "#{release_path}/public"
set :lets_encrypt_challenge_public_path, "#{release_path}/public"

# Set the path where the new certs are going to be saved
# default value: "#{shared_path}/ssl/certs"
set :lets_encrypt_output_path, "#{shared_path}/ssl/certs"

# Set the local path where the certs will be saved
# default value: "~/certs"
# set :lets_encrypt_local_output_path, '~/certs'

# Set the minimum time that the cert should be valid
# default value: 30
# set :lets_encrypt_days_valid, 15

##################
## Deploy stuff ##
##################

namespace :deploy do

  # Now taken care of by capistrano-passenger
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
