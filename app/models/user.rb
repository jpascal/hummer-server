require 'net/ldap'
require 'digest/md5'

class User < ActiveRecord::Base
  attr_accessible :name
  has_many :suites
  acts_as_authentic do |config|
    config.login_field = :login
    config.validate_password_field = false
  end
protected
  def valid_ldap_credentials?(password)
    true
  end
end
