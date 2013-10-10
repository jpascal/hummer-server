class ComparesController < ApplicationController
  load_and_authorize_resource :suite, :id_param => :suite_id
  load_and_authorize_resource :compare, :class => "Suite"
  def index
    @compare = Suite.where("id != ?",@suite).page(params[:page])
  end
  def show
    params[:type] ||= "error"
    @compare = Suite.find(params[:id])
    @cases = @suite.cases.page(params[:page])
    @cases = @cases.where(:results => {:type => params[:type]}) if params[:type]
    @cases = @cases.includes(:result)
    @compares = @cases.collect do |original|
      [original,@compare.cases.includes(:result).where(:name => original.name,:classname => original.classname).first]
    end
  end
end
