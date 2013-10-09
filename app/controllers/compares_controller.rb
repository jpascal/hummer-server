class ComparesController < ApplicationController
  before_filter :load_suite
  def index
    @suites_to_compare = Suite.where("id != ?",@suite).page(params[:page])
  end
  def show
    params[:type] ||= "error"
    @suite_to_compare = Suite.find(params[:id])
    @cases = @suite.cases.page(params[:page])
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
    @cases = @cases.includes(:result)
    @compares = @cases.collect do |original|
      [original,@suite_to_compare.cases.includes(:result).where(:name => original.name,:classname => original.classname).first]
    end
  end
private
  def load_suite
    @suite = Suite.find(params[:report_id])
  end
end
