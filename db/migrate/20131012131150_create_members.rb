class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, :id => :uuid do |t|
      t.uuid :user_id
      t.boolean :owner, :default => false
      t.uuid :project_id
      t.timestamps
    end
  end
end
