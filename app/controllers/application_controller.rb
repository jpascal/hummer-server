class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user

  include Resource::Load
  include Resource::Authorize


  private

  def require_user
    unless current_user
      flash[:warning] = "Require login"
      redirect_to login_path
    end
  end

  def require_guest
    if current_user
      redirect_to url_path(:back)
    end
  end

  def current_session
    return @current_session if defined?(@current_session)
    @current_session = Session.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_session && current_session.user
  end

end
