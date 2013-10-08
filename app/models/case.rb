class Case < ActiveRecord::Base
  attr_accessible :classname, :name, :time
  belongs_to :suite
  has_one :result, :dependent => :delete, :autosave => true
end
