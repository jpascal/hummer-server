class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => :uuid do |t|
      t.string    :email
      t.string    :name
      t.boolean   :active,  :default => false
      t.integer   :login_count, :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.boolean   :admin, :default => false
      t.string    :persistence_token, :null => false
      t.string    :perishable_token, :null => false
      t.string    :crypted_password, :null => false
      t.string    :password_salt, :null => false
      t.timestamps
    end
  end
end
