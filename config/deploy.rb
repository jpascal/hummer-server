require 'dump/capistrano'
require 'bundler/capistrano'
require 'puma/capistrano'

load 'config/recipes/base'
load 'config/recipes/database'
load 'config/recipes/console'

set :application,   "hummer"
set :user,          "hummer"

# Repository
set :repository,    "http://eshurmin@stash.teamcentre.ru/scm/self/hummer.git"
set :scm,           :git
set :branch,        "feature/postgresql"
set :deploy_to,     "/home/#{user}/application"
set :deploy_via,    :copy
set :copy_exclude,  [".git"]

# Servers
server "hummer.vm.mirantis.net", :web, :app, :db, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = false
set :normalize_asset_timestamps,  false
set :shared_children,             %w(bundle log config pids sockets)
set :keep_releases,               3
set :use_sudo,                    false

after "deploy:finalize_update", "database:symlink"
after "deploy:finalize_update", "deploy:precompile"

