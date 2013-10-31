class Api::SuitesController < Api::BaseController
  load_and_authorize_resource :project
  load_and_authorize_resource :suite, :throw => :project
  def index
    render :json => @project.suites.all
  end
  def show
    render :json => @suite
  end
  def create
    @suite.user = current_user
    @suite.project = @project
    if @suite.save
      render :json => @suite
    else
      render :nothing, :status => 402
    end
  end
end
