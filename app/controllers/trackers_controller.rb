class TrackersController < ApplicationController
  resource :project, object: Project, :key => :project_id, :parent => true
  resource :suite, :through => :project, :source => :suites, :key => :suite_id, :parent => true
  resource :case, :through => :suite, :source => :cases, :key => :case_id

  authorize :case
  respond_to :js
  def show
    unless @case.bug.present?
      render :edit
    end
  end
  def update
    bug = @case.bug || @case.build_bug(:name => @case.name, :classname => @case.classname, :user => current_user, :level => @case.type, :message => @case.message)
    if params[:tracker].empty?
      bug.destroy
    else
      bug.tracker = params[:tracker]
      bug.save!
    end
  end
end
