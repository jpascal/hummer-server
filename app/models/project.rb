class Project < ActiveRecord::Base
  self.primary_key = :id
  has_many :suites, :dependent => :destroy

  belongs_to :owner, :class_name => "User"

  validates :name, :owner, :presence => true
  validates :name, :uniqueness => true
  has_many :members
  has_many :users, :through => :members

end
