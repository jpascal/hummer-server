class UsersController < ApplicationController
  before_filter :new_user, :only => :create
  resource :user, object: User
  authorize :user

  def index
    @users = User.order("last_request_at desc")
    @users = @users.where(:active => true) if params[:type] == "active"
    @users = @users.where(:active => false) if params[:type] == "not_actived"
    @users = @users.where(:admin => true) if params[:type] == "admin"
    @users = @users.page(params[:page])
  end
  def show
    @suites = @user.suites.page(params[:page])
    @projects = @user.all_projects
    @bugs = @user.bugs
  end
  def token
    @user.api_token!
    flash[:success] = "API token has been updated"
    redirect_to user_path(@user, :tab => 'personal')
  end
  def edit
  end
  def update
    @user.update(edit_user)
    if @user.save
      flash[:success] = "Profile has been updated successfuly"
      redirect_to :back
    else
      render :edit
    end
  end
  def destroy
    @user.destroy
    flash[:success] = "User has been deleted"
    redirect_to users_path
  end
  def new
  end
  def create
    if @user.save
      redirect_to login_path
    else
      render :new
    end
  end
  def search
    render :json => User.where("name like ? or email like ?", "%#{params[:query]}%", "%#{params[:query]}%").collect{|user| {:name => user.name, :path => user_path(user), :active => user.active, :admin => user.admin}}
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
