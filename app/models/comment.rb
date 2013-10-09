class Comment < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  attr_accessible :message
end
