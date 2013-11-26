class TrackersController < ApplicationController
  load_resource :project
  load_resource :suite, :through => :project
  load_resource :case, :through => :suite
  before_action :try_authorize
  respond_to :js
  def show
    unless @case.bug.present?
      render :edit
    end
  end
  def update
    bug = @case.bug || @case.build_bug(:name => @case.name, :classname => @case.classname, :user => current_user, :level => @case.result.type, :message => @case.result.message)
    if params[:tracker].empty?
      bug.destroy
    else
      bug.tracker = params[:tracker]
      bug.save!
    end
  end
private
  def try_authorize
    authorize!(:track, @case)
  end
end
