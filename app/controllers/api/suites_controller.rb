class Api::SuitesController < Api::BaseController
  resource :project, object: Project, :key => :project_id, :parent => true, :only => [:create, :show]
  resource :suite, :through => :project, :source => :suites, :only => [:create, :show]
  resource :suite, object: Suite, :except => :create
  authorize :suite
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
