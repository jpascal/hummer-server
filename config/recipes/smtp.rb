set_default(:smtp_host) { Capistrano::CLI.ui.ask "SMTP host: " }
set_default(:smtp_port) { Capistrano::CLI.ui.ask "SMTP port: " }
set_default(:smtp_domain) { Capistrano::CLI.ui.ask "SMTP domain: " }

namespace :smtp do
  desc "Generate config for application smtp.yml"
  task :config, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template "smtp.yml.erb", "#{shared_path}/config/smtp.yml"
  end
  desc "Symlink the smtp.yml file into latest release"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/smtp.yml #{release_path}/config/smtp.yml"
  end
end
