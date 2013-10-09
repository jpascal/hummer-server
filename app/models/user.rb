require 'net/ldap'

class User < ActiveRecord::Base
  attr_accessible :name
  has_many :suites
  acts_as_authentic do |config|
    config.login_field = :login
    config.validate_password_field = false
  end
protected
  def valid_ldap_credentials?(password)
    begin
      puts "LDAP bind user"
      ldap = Net::LDAP.new(:host => '127.0.0.1',
                           :auth => {
                               :method => :simple,
                               :username => "cn=#{self.login},dc=localhost",
                               :password => password
                           })
      ldap.bind
    rescue => e
      Rails.logger.error e.message
      return false
    end
  end
end
