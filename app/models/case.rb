class Case < ActiveRecord::Base
  self.primary_key = :id
  paginates_per 20
  belongs_to :suite
  has_one :result, :dependent => :delete, :autosave => true
  belongs_to :tracker_user, :class_name => "User"
end
