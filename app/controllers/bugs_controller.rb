class BugsController < ApplicationController
  def index
    @bugs = Case.where("tracker IS NOT NULL").page(params[:page])
    authorize!(:index, Case)
  end
  def show
    @bug = Case.where("tracker IS NOT NULL").find(params[:id])
    authorize!(:read, @bug)
  end
end
