class UsersController < ApplicationController
  load_and_authorize_resource
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
  end
  def create
    if @user.save
      flash.now[:success] = t(".success")
      redirect_to login_path
    else
      render :new
    end
  end
private
  def user_params
    params.require(:user).permit(:name, :login, :password, :password_confirmation)
  end
end
