class ProjectsController < ApplicationController
  before_filter :new_project, :only => :create
  load_and_authorize_resource
  def index

  end
  def create
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
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
    params.require(:project).permit(:name)
  end
  def new_project
    @project = Project.new(project_params)
    @project.owner = current_user
  end
end
