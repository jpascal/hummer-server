class Result < ActiveRecord::Base
  self.primary_key = :id
  belongs_to :case
  def self.inheritance_column
    "rails_type"
  end
end
