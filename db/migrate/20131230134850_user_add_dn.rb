class UserAddDn < ActiveRecord::Migration
  def up
    add_column :users, :dn, :string, :default => nil
    change_column :users, :crypted_password, :string, :null => true
    change_column :users, :password_salt, :string, :null => true
  end
  def down
    change_column :users, :password_salt, :string, :null => false
    change_column :users, :crypted_password, :string, :null => false
    remove_column :users, :dn
  end
end
