class UserLdapFlag < ActiveRecord::Migration
  def up
    add_column :users, :dn, :string, :default => nil
  end
  def down
    remove_column :users, :dn
  end
end
