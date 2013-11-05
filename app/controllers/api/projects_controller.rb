class Api::ProjectsController < Api::BaseController
  load_and_authorize_resource
  def index
    render :json => Project.order("created_at desc").all.collect{|p| p.as_json}
  end
  def show
    render :json => @project.as_json
  end
end
