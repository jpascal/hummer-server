class Api::ProjectsController < Api::BaseController
  resource :project, object: Project
  authorize :project
  def index
    render :json => Project.for(current_user).order("created_at desc").all.collect{|p| p.as_json}
  end
  def show
    render :json => @project.as_json
  end
end
