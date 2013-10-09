class Case < ActiveRecord::Base
  paginates_per 20
  attr_accessible :classname, :name, :time
  belongs_to :suite
  has_one :result, :dependent => :delete, :autosave => true
  has_many :comments, :as => :resource, :dependent => :delete_all, :order =>  "created_at desc"
end
