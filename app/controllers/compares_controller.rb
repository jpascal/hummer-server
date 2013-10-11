class ComparesController < ApplicationController
  load_and_authorize_resource :suite, :id_param => :suite_id
  load_and_authorize_resource :compare, :class => "Suite"
  def index
    @compares = @compares.where("id != ?",@suite).page(params[:page])
  end
  def show
    if params[:id] == @suite.id.to_s
      flash[:warning] = "You can't compare equal suites"
      redirect_to suites_path
    end
    params[:type] ||= "error"
    @cases = @suite.cases.page(params[:page])
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
    @cases = @cases.includes(:result)
    @compares = @cases.collect do |original|
      [original,@compare.cases.includes(:result).where(:name => original.name,:classname => original.classname).first]
    end
  end
end
