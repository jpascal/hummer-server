class Api::ProjectsController < Api::BaseController
  load_and_authorize_resource
  def index
    render :json => Project.all
  end
  def show
    render :json => @project
  end
end
