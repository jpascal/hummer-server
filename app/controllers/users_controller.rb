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
    @user = User.new user_params
    if @user.save
      flash.now[:success] = t(".success")
    else
      render :new
    end
  end
private
  def user_params
    params.require(:user).permit(:name, :login, :password, :password_confirmation)
  end
end
