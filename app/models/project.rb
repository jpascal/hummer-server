class Project < ActiveRecord::Base
  self.primary_key = :id
  has_many :suites, :dependent => :destroy

  belongs_to :owner, :class_name => "User"

  validates :name, :owner_id, :presence => true
  validates :name, :uniqueness => true
  has_many :members
  has_many :users, :through => :members

  acts_as_taggable_on :default_features

end
