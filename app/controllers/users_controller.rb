class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def edit

  end
  def update

  end
  def destroy

  end
  def new
    @user = User.new
  end
  def create
    @user = User.new params[:user]
    if @user.save
      flash.now[:success] = t(".success")
    else
      render :new
    end
  end
end
