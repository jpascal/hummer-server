class SuitesController < ApplicationController
  helper_method :sort_column, :sort_direction
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :suite, :through => :project, :source => :suites
  authorize :suite

  def index
    @suites = @project.suites
    @suites = @suites.page(params[:page]).order(sort_column + " " + sort_direction)
    @suites = @suites.tagged_with(params[:feature]) if params[:feature].present?
    @suites = @suites.references(:features)
  end

  def create
    @suite.user = current_user
    @suite.project = @project
    if @suite.save
      redirect_to suites_path
    else
      render :new
    end
  end
  def new
    @suite.feature_list = @project.feature_list
  end
  def edit

  end
  def update
    @suite.update(update_suite)
    if @suite.save!
      redirect_to suites_path
    else
      render :edit
    end
  end
  def paste
    unless @suite.paste
      @suite.paste = Paste2::Client.post(@suite.tempest.read)
      @suite.save!
    end
    redirect_to @suite.paste
  end
  def reload
    @suite.reload
    redirect_to suites_path
  end
  def show
    @cases = @suite.cases.page(params[:page])
    @cases = @cases.where(:type => params[:type]) if params[:type]
  end
  def destroy
    if @suite.destroy
      redirect_to suites_path
    end
  end
  def search
    render :json => Case.includes(:suite).where("suite_id = ? and name like ?", params[:id],"%#{params[:query]}%").collect{|test| {:name => test.name, :path => project_suite_case_path(test.suite.project_id,test.suite_id,test), :type => test.type}}
  end
private
  def update_suite
    params.require(:suite).permit(:build, :project_id, :feature_list)
  end
  def sort_column
    Suite.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
