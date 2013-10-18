class AddTrackerCreator < ActiveRecord::Migration
  def up
    add_column :cases, :tracker_user_id, :uuid
    Case.where("tracker IS NOT NULL").each do |c|
      c.tracker_user = c.suite.user
      c.save!
    end
  end
  def down
    remove_column :cases, :tracker_user_id
  end
end
