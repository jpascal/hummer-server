class ProjectOwnerToMembers < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.members.create!(:user => project.owner, :owner => true)
      project.owner = nil
      project.save!
    end
    remove_column :projects, :owner_id
  end
  def down
    add_column :projects, :owner_id, :uuid
    Project.all.each do |project|
      project.update!(:owner => project.members.where(:owner => true).first.user)
    end
    Member.delete_all
  end
end
