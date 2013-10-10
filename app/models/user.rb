class User < ActiveRecord::Base
  validates :name, :length => { :minimum => 4 }
  has_many :suites
  acts_as_authentic do |config|
    config.login_field = :login
  end
end
