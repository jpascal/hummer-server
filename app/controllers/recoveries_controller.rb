class RecoveriesController < ApplicationController
  def new
    authorize!(:recovery, User)

  end
  def create
    @user = User.find_by_email(params[:email])
    authorize!(:recovery, @user)
    if @user
      Mailer::Recovery.instructions(@user,request).deliver
      flash[:info] = "Instructions to reset your password have been emailed to you"
      redirect_to login_path
    else
      flash.now[:warning] = "No user was found with email address #{params[:email]}"
      render :action => :new
    end
  end
  def show
    @user = User.find_by_perishable_token!(params[:id])
    authorize!(:recovery, @user)
    @password_form = PasswordForm.new(@user)
  end
  def update
    @user = User.find_by_perishable_token!(params[:id])
    authorize!(:recovery, @user)
    @password_form = PasswordForm.new(@user)
    if @password_form.submit(recovery_params)
      flash[:info] = "Password for user #{@user.name} updated!"
      redirect_to login_path
    else
      render :show
    end
  end
private
  def recovery_params
    params.require(:user).permit(:password,:password_confirmation)
  end
end
