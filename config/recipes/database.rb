set_default(:database_host, "localhost")
set_default(:database_user) { application }
set_default(:database_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:database_name) { "#{application}_production" }
set_default(:database_pool, 5)

namespace :database do
  desc "Generate config for application database.yml"
  task :config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template "database.yml.erb", "#{shared_path}/config/database.yml"
  end
  desc "Symlink the database.yml file into latest release"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
