class Project < ActiveRecord::Base
  self.primary_key = :id
  has_many :suites, :dependent => :destroy

  belongs_to :owner, :class_name => "User"

  validates :name, :owner_id, :presence => true
  validates :name, :uniqueness => true
  has_many :members
  has_many :users, :through => :members

  acts_as_taggable_on :features
  def owner_name
    owner.name || ""
  end
  def as_json
    super(:methods => [:feature_list,:owner_name],:except => :owner_id)
  end
end
