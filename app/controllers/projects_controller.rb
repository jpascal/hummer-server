class ProjectsController < ApplicationController
  before_filter :new_project, :only => :create
  before_filter :load_users, :only => [:edit,:update,:create,:new]
  load_and_authorize_resource
  def index

  end
  def show
    @suites = @project.suites.page(params[:page]).order(suites_sort_column + " " + suites_sort_direction)
    @suites = @suites.tagged_with(params[:feature]) if params[:feature].present?
  end
  def create
    @users = User.where(:active => true)
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end
  def new
    @project.owner = current_user
  end
  def destroy
    @project.destroy
    redirect_to :back
  end
  def update
    @project.update(project_params)
    if @project.save
      redirect_to projects_path
    else
      render :edit
    end
  end
private
  def project_params
    if current_user.admin or @project.owner == current_user
      params.require(:project).permit(:name, :owner_id, :feature_list)
    else
      params.require(:project).permit(:name, :feature_list)
    end
  end
  def new_project
    @project = Project.new(project_params)
  end
  def load_users
    @users = User.where(:active => true)
  end
  def suites_sort_column
    Suite.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  def suites_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
