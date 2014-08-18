require 'bundler/capistrano'
require 'puma/capistrano'

load 'config/recipes/config'

load 'config/recipes/base'
load 'config/recipes/database'
load 'config/recipes/console'
load 'config/recipes/dump'

set :application,   "hummer"
set :user,          config["user"]

# Repository
set :repository,    config["repository"]
set :scm,           :git
set :branch,        :master
set :deploy_to,     config["deploy_to"]
set :deploy_via,    :copy
set :copy_exclude,  [".git"]

# Servers
config["servers"].each do |node, roles|
  server node, *roles
end

default_run_options[:pty] = true
ssh_options[:forward_agent] = false
set :normalize_asset_timestamps,  false
set :shared_children,             %w(log sockets)
set :keep_releases,               3
set :use_sudo,                    false

after "deploy:finalize_update", "database:symlink"
#after "deploy:finalize_update", "smtp:symlink"
after "deploy:finalize_update", "deploy:migrate"
after "deploy:finalize_update", "deploy:uploads"
after "deploy:finalize_update", "deploy:precompile"

after "deploy:setup", "database:config"
