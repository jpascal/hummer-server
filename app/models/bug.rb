class Bug < ActiveRecord::Base
  belongs_to :case
  belongs_to :user
  has_one :suite, :through => :case
end
