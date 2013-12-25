class Member < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :user, :presence => true
end
