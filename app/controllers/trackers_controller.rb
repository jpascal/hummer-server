class TrackersController < ApplicationController
  load_and_authorize_resource :suite
  load_and_authorize_resource :case, :through => :suite
  respond_to :js
  def edit
    authorize!(:track, @case)
  end
  def show
    unless @case.tracker
      authorize!(:track, @case)
      render :edit
    end
  end
  def update
    authorize!(:track, @case)
    @case.tracker = params[:tracker].empty? ? nil : params[:tracker]
    @case.save!
  end
end
