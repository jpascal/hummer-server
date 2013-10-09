class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :login
      t.string    :name
      t.integer   :login_count, :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :persistence_token, :null => false
      t.string    :perishable_token, :null => false
      t.timestamps
    end
  end
end
