class SessionsController < ApplicationController
  before_filter :require_guest, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @session = Session.new
  end
  def create
    @session = Session.new(params[:session])
    if params[:session]
      @user = User.find_or_create_by_login(params[:session][:login])
    end
    if @session.save
      flash[:success] = "Sign in success"
      redirect_to root_path
    else
      @user.destroy
      render :new
    end
  end
  def destroy
    current_session.destroy
    flash[:success] = "Sign out success"
    redirect_to login_path
  end
end
