class Session < Authlogic::Session::Base
  authenticate_with User
  verify_password_method :valid_ldap_credentials?
end