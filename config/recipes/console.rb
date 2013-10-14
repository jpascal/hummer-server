namespace :deploy do
  desc "Open application console"
  task :console do
    exec %{ssh #{user}@#{domain} -t "cd #{current_path} && bundle exec rails console #{rails_env}"}
  end
  desc "Open shell to remote server"
  task :shell do
    exec %{ssh #{user}@#{domain} -t "cd #{current_path} && bash"}
  end
end