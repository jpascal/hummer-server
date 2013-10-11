class User < ActiveRecord::Base
  validates :name, :length => { :minimum => 4 }
  has_many :suites
  paginates_per 20

  before_create do
    if User.count == 0
      self.admin = true
      self.active = true
    end
  end

  acts_as_authentic do |config|
    config.login_field = :email
  end
end
