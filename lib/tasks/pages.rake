namespace :assets do
  desc 'Compile the static pages from app/views/*.haml to public/*.html (must run after assets:precompile)'
  task :pages => :environment do
    require "sprockets/railtie"
    logger = Logger.new STDOUT
    action_view = ActionView::Base.new(Rails.root.join('app', 'views'))
    include Rails.application.routes.url_helpers
    Dir.glob("app/views/*.haml").each do |template|
      page = template.scan(/([\w\.]+).haml$/).join
      target = File.expand_path(Rails.root.join("public",page))
      logger.info "Writing #{target}.html"
      File.new(Rails.root.join("public",page+".html"),"w+") << action_view.render(:template => page, :layout => "layouts/errors", :formats => :html, :handlers => :haml, :locale => :en)
    end
  end
end
