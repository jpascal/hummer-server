class Mailer::Recovery < ActionMailer::Base
  default sender: "noreplay@hummer.mirantis.com"
  def instructions user, request = nil
    @user = user
    @request = request
    mail :subject => "Password Reset Instructions", :to => user.email
  end
end
