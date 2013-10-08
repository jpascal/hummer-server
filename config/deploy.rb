require 'dump/capistrano'
require 'bundler/capistrano'
require 'puma/capistrano'

set :application,   "Hummer"
set :user,          "hummer"

# Repository
set :repository,    "http://eshurmin@stash.teamcentre.ru/scm/self/hummer.git"
set :scm,           :git
set :deploy_to,     "/home/#{user}/application"
set :deploy_via,    :copy
set :copy_exclude,  [".git"]

# Servers
server "172.18.12.13", :web, :app, :db, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = false
set :normalize_asset_timestamps,  false
set :shared_children,             %w(bundle log config pids sockets)
set :keep_releases,               3
set :use_sudo,                    false

