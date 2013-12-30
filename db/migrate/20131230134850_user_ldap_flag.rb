class UserLdapFlag < ActiveRecord::Migration
  def up
    add_column :users, :dn, :string, :default => nil
    add_column :users, :ldap, :boolean, :default => false
  end
  def down
    remove_column :users, :dn
    remove_column :users, :ldap
  end
end
