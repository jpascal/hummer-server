class Session < Authlogic::Session::Base
  authenticate_with User
  remember_me_for 2.weeks
  logged_in_timeout = 2.hours
end