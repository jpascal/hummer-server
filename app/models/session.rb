class Session < Authlogic::Session::Base
  authenticate_with User

  generalize_credentials_error_messages "Email/Password combination is not valid"

  verify_password_method :valid_credentials?
  find_by_login_method  :find_user_or_create_ldap_user

  remember_me_for 2.weeks

end