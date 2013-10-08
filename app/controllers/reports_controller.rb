class ReportsController < ApplicationController
  def index
    @suites = Suite.page(params[:page]).order("created_at desc")
  end
  def new
    @suite = Suite.new
  end
  def create
    @suite = Suite.new(params[:suite])
    if @suite.save
      redirect_to report_path @suite
    else
      render :new
    end
  end
  def paste
    @suite = Suite.find(params[:id])
    unless @suite.paste
      @suite.paste = Paste2::Client.post(@suite.tempest.read)
      @suite.save!
    end
    redirect_to @suite.paste
  end
  def show
    @suite = Suite.find(params[:id])
    @cases = @suite.cases.includes(:result).page(params[:page])
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
  end
  def destroy
    @suite = Suite.find(params[:id])
    if @suite.destroy
      redirect_to reports_path
    end
  end
end
