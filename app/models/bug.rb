class Bug < ActiveRecord::Base
  belongs_to :case
  has_one :suite, :through => :case
end
