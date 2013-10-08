class ReportsController < ApplicationController
  def index
    @suites = Suite.page(params[:page])
  end
  def show
    @suite = Suite.find(params[:id])
    @cases = @suite.cases.includes(:result)
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
  end
  def destroy
    @suite = Suite.find(params[:id])
    if @suite.destroy
      redirect_to :index
    end
  end
end
