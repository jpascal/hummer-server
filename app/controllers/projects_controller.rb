class ProjectsController < ApplicationController
  resource :project, object: Project
  authorize :project

  def index
    @projects = Project.all
  end

  def show
    @suites = @project.suites.limit(5)
    @top_broken_tests = @project.cases.joins(:suite).where("suites.created_at > ?",30.days.ago).where.not(:type => [:passed,:skipped]).limit(10).order("count_all desc").count(:group => "cases.name")
    @top_longest_tests = @project.cases.joins(:suite).where("suites.created_at > ?",30.days.ago).order("time desc").where.not(:type => [:passed,:skipped]).limit(10)
  end

  def create
    @project.update(project_params)
    @project.members.build(:user => current_user, :owner => true)
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end

  def new
    @project = current_user.owner_of_projects.build
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

  def suites_sort_column
    Suite.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def suites_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
