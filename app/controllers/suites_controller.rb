class SuitesController < ApplicationController
  load_and_authorize_resource
  def index
    @suites = Suite.page(params[:page]).order("created_at desc")
  end
  def new
  end
  def create
    @suite = Suite.new(report_params)
    if @suite.save
      redirect_to suite_path @suite
    else
      render :new
    end
  end
  def paste
    unless @suite.paste
      @suite.paste = Paste2::Client.post(@suite.tempest.read)
      @suite.save!
    end
    redirect_to @suite.paste
  end
  def show
    @cases = @suite.cases.includes(:result).page(params[:page])
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
  end
  def destroy
    if @suite.destroy
      redirect_to suites_path
    end
  end
  def search
    render :json => Case.includes(:result).where("suite_id = ? and name like ?", params[:id],"%#{params[:query]}%").collect{|test| {:name => test.name, :path => suite_case_path(params[:id],test), :type => test.result.type}}
  end
  private
  def report_params
    params.require(:report).permit(:build, :tempest)
  end
end
