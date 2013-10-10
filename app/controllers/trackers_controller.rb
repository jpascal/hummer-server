class TrackersController < ApplicationController
  load_and_authorize_resource :suite
  load_and_authorize_resource :case, :through => :suite
  respond_to :js
  def edit

  end
  def show
    unless @case.tracker
      render :edit
    end
  end
  def update
    @case.tracker = params[:tracker].empty? ? nil : params[:tracker]
    @case.save!
  end
end
