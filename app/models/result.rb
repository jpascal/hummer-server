class Result < ActiveRecord::Base
  belongs_to :case
  def self.inheritance_column
    "rails_type"
  end
end
