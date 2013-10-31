class Api::BaseController < ApplicationController
  respond_to :json
  rescue_from Exception do |exception|
    render :json => {:error => "Internal error"}, :status => 500
  end
  before_filter :load_user
private
  def load_user
    @current_user = User.where(:id => request.headers["X-User-ID"]).first
    unless @current_user
      render :json => {:error => "Unknown user"}, :status => 401
      return false
    end
  end
end
