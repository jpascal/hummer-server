module Permissions
  def self.for(user)
    Permissions::User.new(user)
  end
end