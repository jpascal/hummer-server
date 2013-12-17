class ProjectsController < ApplicationController
  resource :project, object: Project
  authorize :project

  def index
    @projects = Project.all
  end

  def show
    @top_longest_tests = @project.cases.order("time desc").where.not(:type => [:passed,:skipped]).limit(10)
    @number_of_tests = @project.suites.order('created_at desc').limit(10)
    @top_broken_tests = Case.where(:suite_id => @project.suite_ids).where.not(:type => [:passed,:skipped]).limit(10).select("cases.name, cases.suite_id, cases.id, cases.type")
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

  def suites_sort_column
    Suite.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def suites_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
