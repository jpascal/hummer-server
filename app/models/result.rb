class Result < ActiveRecord::Base
  attr_accessible :type, :name, :message
  belongs_to :case
  def self.inheritance_column
    "rails_type"
  end
end
