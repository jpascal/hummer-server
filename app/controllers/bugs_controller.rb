class BugsController < ApplicationController
  def index
    @bugs = Case.where("tracker IS NOT NULL").includes(:result)
    @total_tests = @bugs.count
    @total_errors = @bugs.where(:results => {:type => "error"}).count
    @total_failures = @bugs.where(:results => {:type => "failure"}).count
    @total_skipped = @bugs.where(:results => {:type => "skipped"}).count

    @bugs = @bugs.where(:results => {:type => params[:type]}) if params[:type].present?
    @bugs = @bugs.page(params[:page])
    authorize!(:index, Case)
  end
  def show
    @bug = Case.where("tracker IS NOT NULL").find(params[:id])
    authorize!(:read, @bug)
  end
end
