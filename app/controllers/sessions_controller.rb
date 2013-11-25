class SessionsController < ApplicationController
  load_and_authorize_resource

  before_filter :require_guest, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @session = Session.new
  end
  def create
    @session = Session.new(params[:session])
    if @session.save
      begin
        Rails.application.routes.recognize_path (request[:path]) if request[:path].present?
        flash[:success] = "Sign in success"
        redirect_to request[:path]
      rescue
        if params[:path].present?
            flash[:warning] = "Sign in success, but invalid route returning"
        end
        redirect_to root_path
      end
    else
      render :new
    end
  end
  def destroy
    current_session.destroy
    flash[:success] = "Sign out success"
    redirect_to login_path
  end
end
