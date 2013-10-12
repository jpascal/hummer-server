class UsersController < ApplicationController
  before_filter :new_user, :only => :create
  load_and_authorize_resource
  def index
    @users = User.page(params[:page])
  end
  def show
    @suites = @user.suites.page(params[:page])
    @projects = @user.projects
  end
  def edit
  end
  def update
    @user.update(edit_user)
    if @user.save
      redirect_to user_path(@user)
    else
      render :edit
    end
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
  def edit_user
    if current_user.admin
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :active, :admin)
    else
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  def new_user
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    @user = User.new(user_params)
  end
end
