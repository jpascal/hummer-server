class CreateBugs < ActiveRecord::Migration
  def up
    create_table :bugs, :id => :uuid do |t|
      t.uuid    :case_id
      t.uuid    :user_id
      t.string  :tracker
      t.string  :level
      t.string  :name
      t.string  :classname
      t.text    :message
      t.timestamps
    end
    Case.where("tracker IS NOT NULL").includes(:result).each do |test|
      Bug.create!(
        :level => test.result.type,
        :user_id => test.tracker_user_id,
        :case_id => test.id,
        :tracker => test.tracker,
        :message => test.result.message,
        :name => test.name,
        :classname => test.classname,
        :created_at => test.updated_at,
        :updated_at => test.created_at
      )
    end
    remove_columns :cases, :tracker, :tracker_user_id
  end
  def down
    add_column :cases, :tracker_user_id, :uuid
    add_column :cases, :tracker, :string
    Bug.all.each do |bug|
      if bug.suite.present?
        Case.where(
          :id => bug.case_id,
          :name => bug.name,
          :classname => bug.classname
        ).update_all(
          :tracker => bug.tracker,
          :tracker_user_id => bug.user_id
        )
      end
    end
    drop_table :bugs
  end
end
