set :config, YAML.load_file('config/deploy.yml')

unless config['repository']
  puts 'Please, fill repository URL in config/deploy.yml'
  exit(1)
end

unless config['servers']
  puts 'Please, fill servers in config/deploy.yml'
  exit(1)
end

unless config["deploy_to"]
  puts 'Please, fill deploy_to in config/deploy.yml'
  exit(1)
end

unless config["user"]
  puts 'Please, fill user config/deploy.yml'
  exit(1)
end
