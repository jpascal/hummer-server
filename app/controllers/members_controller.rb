class MembersController < ApplicationController
  respond_to :json, :except => :index
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :member, :through => :project, :source => :members
  authorize :project, :only => [:new, :create]
  authorize :member, :except => [:new, :create]
  def index
    @members = @project.members
  end
  def edit

  end
  def destroy
    @member.destroy
  end
end
