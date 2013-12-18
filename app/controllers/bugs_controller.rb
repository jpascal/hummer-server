class BugsController < ApplicationController
  authorize
  def index
    @bugs = Bug.all
    @total_tests = @bugs.count
    @total_errors = @bugs.where(:level => "error").count
    @total_failures = @bugs.where(:level => "failure").count
    @total_skipped = @bugs.where(:level => "skipped").count

    @bugs = @bugs.where(:level => params[:type]) if params[:type].present?
    @bugs = @bugs.page(params[:page])
  end
end
