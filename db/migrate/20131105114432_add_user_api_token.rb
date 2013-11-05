class AddUserApiToken < ActiveRecord::Migration
  def change
    add_column :users, :api_token, :string, :default => nil
    User.all.each do |user|
      user.api_token!
    end
  end
end
