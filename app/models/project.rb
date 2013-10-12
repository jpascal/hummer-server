class Project < ActiveRecord::Base
  has_many :suites, :dependent => :delete_all
  belongs_to :user
  validates :name, :user, :presence => true
  validates :name, :uniqueness => true
end
