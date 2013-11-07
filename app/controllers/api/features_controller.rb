class Api::FeaturesController < Api::BaseController
  def index
    render :json => ActsAsTaggableOn::Tag.joins(:taggings).where(:taggings => { :context => "features", :taggable_type => "Suite"}).as_json
  end
  def show
    render :json => ActsAsTaggableOn::Tag.joins(:taggings).where(:id => params[:id], :taggings => { :context => "features", :taggable_type => "Suite"}).first.as_json
  end
end
