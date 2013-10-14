require "erb" # Erb template engine

# for generate config file from *.erb templates
def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

# set variable to default value
def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

# for install deb packages
def packages debs, role
  run "#{sudo} apt-get -y update && #{sudo} apt-get -y upgrade && #{sudo} apt-get install -y #{debs}", :role => role
end

# for control services stop,restart,start and other
def service name, operation, role
  run "#{sudo} /etc/init.d/#{name} #{operation}", :role => role
end

namespace :deploy do
  task :uploads, :roles => :web, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/uploads && ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  task :precompile, :roles => :web, :except => { :no_release => true } do
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} RAILS_GROUPS=assets assets:precompile"
  end
end
