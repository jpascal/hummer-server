class TrackersController < ApplicationController
  before_filter :load_suite_and_case
  respond_to :js
  def edit

  end
  def show
    unless @case.tracker
      render :edit
    end
  end
  def destroy
    @case.tracker = nil
    @case.save!
  end
  def update
    @case.tracker = params[:tracker]
    @case.save!
  end
private
  def load_suite_and_case
    @suite = Suite.find(params[:report_id])
    @case = @suite.cases.find(params[:case_id])
  end
end
