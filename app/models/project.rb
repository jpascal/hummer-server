class Project < ActiveRecord::Base
  self.primary_key = :id
  has_many :suites, :dependent => :destroy

  belongs_to :owner, :class_name => "User"

  validates :name, :presence => true
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

  # TODO: rewrire to
  # example: has_many :spam_comments, -> { where spam: true }, class_name: 'Comment'
  has_many :all_features, :through => :suites, :source => :features, :uniq => true
  has_many :cases, :through => :suites, :source => :cases
  has_many :bugs, :through => :cases, :source => :bug

  def self.for(user = nil)
    if user and user.admin?
      Project.all
    elsif user
      user.projects
    else
      where(:private => false)
    end
  end

end
