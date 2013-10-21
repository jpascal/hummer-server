class SuitesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :new_suite, :only => :create
  load_and_authorize_resource
  def index
    @suites = @suites.page(params[:page]).order(sort_column + " " + sort_direction)
    @suites = @suites.tagged_with(params[:feature]) if params[:feature].present?
    @features = ActsAsTaggableOn::Tag.joins(:taggings).where(:taggings => { :context => "features", :taggable_type => "Suite"}).uniq
  end
  def create
    @suite.user = current_user
    if @suite.save
      redirect_to suite_path @suite
    else
      render :new
    end
  end
  def edit

  end
  def update
    @suite.update(update_suite)
    if @suite.save!
      redirect_to suite_path(@suite)
    else
      render :edit
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
  def update_suite
    params.require(:suite).permit(:build, :project_id, :feature_list)
  end
  def sort_column
    Suite.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  def new_suite
    suite_params = params.require(:suite).permit(:build, :tempest, :project_id, :feature_list)
    @suite = Suite.new(suite_params)
  end
end
