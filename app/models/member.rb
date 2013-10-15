class Member < ActiveRecord::Base
  self.primary_key = :id
  belongs_to :project
  belongs_to :user
end
