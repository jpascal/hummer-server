namespace :dump do
  namespace :local do
    desc "Creates remote dump, downloads and restores on local"
    task :mirror, :roles => :db, :only => {:primary => true} do
      backup
      file = capture "cd #{current_path} ; RAILS_ENV=#{rails_env} #{rake} dump TAG=capistrano 2> /dev/null"
      download "#{current_path}/dump/#{file.chomp}", "dump/#{file.chomp}"
      puts run_locally "bundle exec #{rake} dump:restore LIKE=#{file.chomp} 2> /dev/null"
    end
    desc "Create backup locally"
    task :backup, :roles => :db, :only => {:primary => true} do
      run_locally "bundle exec #{rake} dump TAG=capistrano 2> /dev/null"
    end
    desc "Restore backup locally"
    task :restore, :roles => :db, :only => {:primary => true} do
      puts run_locally "bundle exec #{rake} dump:restore TAG=capistrano 2> /dev/null"
    end
    desc "Versions of local dumps"
    task :versions, :roles => :db, :only => {:primary => true} do
      puts run_locally "bundle exec #{rake} dump:versions 2> /dev/null"
    end
    desc "Cleanup local dumps"
    task :cleanup, :roles => :db, :only => {:primary => true} do
      puts run_locally "bundle exec #{rake} dump:cleanup 2> /dev/null"
    end
  end
  namespace :remote do
    desc "Creates local dump, uploads and restore on remote"
    task :mirror, :roles => :db, :only => {:primary => true} do
      backup
      file = run_locally "#{rake} dump TAG=capistrano 2> /dev/null"
      upload "dump/#{file.chomp}", "#{current_path}/dump/#{file.chomp}"
      run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec #{rake} dump:restore LIKE=#{file.chomp} 2> /dev/null"
    end
    desc "Create backup on remote server"
    task :backup, :roles => :db, :only => {:primary => true} do
      run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec #{rake} dump TAG=capistrano 2> /dev/null"
    end
    desc "Restore last backup on remote server"
    task :restore, :roles => :db, :only => {:primary => true} do
      run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec #{rake} dump:restore TAG=capistrano 2> /dev/null"
    end
    desc "Versions of remote dumps"
    task :versions, :roles => :db, :only => {:primary => true} do
      puts capture "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec  #{rake} dump:versions 2> /dev/null"
    end
    desc "Cleanup remote dumps"
    task :cleanup, :roles => :db, :only => {:primary => true} do
      versions = capture "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec #{rake} dump:cleanup 2> /dev/null"
      puts versions
    end
  end
end