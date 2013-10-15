class User < ActiveRecord::Base
  self.primary_key = :id
  validates :name, :length => { :minimum => 4 }
  has_many :suites
  has_many :projects_of_suites, :through => :suites, :source => :project
  has_many :owner_of_projects, :dependent => :nullify, :foreign_key => :owner_id, :class_name => "Project"

  has_many :members, :dependent => :delete_all
  has_many :member_of_projects, :through => :members, :source => :project

  def all_projects
    # TODO: return this when members will be full implemented
    #(self.owner_of_projects + self.member_of_projects + self.projects_of_suites).uniq
    Project.all
  end
  def all_projects_ids
    all_projects.collect{|project| project.id}
  end

  paginates_per 20

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
