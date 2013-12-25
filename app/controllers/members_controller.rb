class MembersController < ApplicationController
  respond_to :json, :except => :index
  resource :project, :object => Project, :key => :project_id, :parent => true
  resource :member, :through => :project, :source => :members
  authorize :project, :only => [:new, :create]
  authorize :member, :except => [:new, :create]
  def index
    @members = @project.members
  end
  def new

  end
  def update
    @member.update(member_params)
    unless @member.save
      render :edit
    end
  end
  def destroy
    @member.destroy
  end
private
  def member_params
    params.require(:member).permit(:owner)
  end
end
