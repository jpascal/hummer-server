class Api::SuitesController < Api::BaseController
  load_and_authorize_resource :project, :only => :create
  load_and_authorize_resource :suite, :throw => :project, :only => :create
  load_and_authorize_resource :suite, :except => :create
  def index
    if @project
      render :json => @project.suites.order("created_at desc").as_json
    else
      render :json => Suite.all.order("created_at desc").as_json
    end
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
