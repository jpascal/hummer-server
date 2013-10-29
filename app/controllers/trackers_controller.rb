class TrackersController < ApplicationController
  load_resource :project
  load_resource :suite, :through => :project
  load_resource :case, :through => :suite
  before_action :try_authorize
  respond_to :js
  def show
    unless @case.tracker
      render :edit
    end
  end
  def update
    @case.tracker = params[:tracker].empty? ? nil : params[:tracker]
    @case.tracker_user = current_user
    @case.save!
  end
private
  def try_authorize
    authorize!(:track, @case)
  end
end
