if ActionMailer::Base.delivery_method == :smtp
  ActionMailer::Base.smtp_settings = YAML.load_file(Rails.root.join('config', 'smtp.yml'))[Rails.env].try(:to_options)
end
