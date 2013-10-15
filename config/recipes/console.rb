namespace :deploy do
  desc "Open application console"
  task :console do
    server = find_servers(:roles => :app, :except => { :no_release => true }).first
    exec %{ssh #{user}@#{server} -t "cd #{current_path} && bundle exec rails console #{rails_env}"}
  end
  desc "Open shell to remote server"
  task :shell do
    server = find_servers(:roles => :app, :except => { :no_release => true }).first
    exec %{ssh #{user}@#{server} -t "cd #{current_path} && bash"}
  end
end