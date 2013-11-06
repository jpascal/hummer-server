class Api::SuitesController < Api::BaseController
  load_and_authorize_resource :project
  load_and_authorize_resource :suite, :throw => :project
  def index
    render :json => @project.suites.order("created_at desc").as_json
  end
  def show
    render :json => @suite.as_json
  end
  def create
    @suite.update_attributes(params.permit(:build, :tempest, :feature_list))
    @suite.user = current_user
    @suite.project = @project
    @suite.feature_list = (@suite.feature_list.split(",") + @project.feature_list.split(",")).join(",")
    if @suite.save
      render :json => @suite.as_json
    else
      render :nothing, :status => 402
    end
  end
end
