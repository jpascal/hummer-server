class Case < ActiveRecord::Base
  self.primary_key = :id
  paginates_per 20
  belongs_to :suite
  has_one :result, :dependent => :delete, :autosave => true
end
