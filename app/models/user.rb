class User < ActiveRecord::Base
  validates :name, :length => { :minimum => 4 }
  has_many :suites
  paginates_per 20

  validate

  before_create do
    if User.count == 0
      self.admin = true
      self.active = true
    end
  end

  validate :custom_validate
  def custom_validate
    if (self.admin_change == [true, false] or self.active_change == [true, false]) and User.where(:admin => true, :active => true).count == 1
      errors.add :base, "Can't uncheck admin/active for this user."
    end
    if self.password_confirmation.present? and self.password_confirmation != self.password
      errors.add :password, "doesn't match Password confirmation"
    end
  end

  acts_as_authentic do |config|
    config.login_field = :email
  end
end
