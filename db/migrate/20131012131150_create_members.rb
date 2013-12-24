class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, :id => :uuid do |t|
      t.uuid :user_id, :null => false
      t.uuid :project_id, :null => false
      t.timestamps
    end
  end
end
