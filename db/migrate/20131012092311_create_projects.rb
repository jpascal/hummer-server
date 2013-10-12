class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, :id => :uuid do |t|
      t.string  :name
      t.uuid    :owner_id
      t.timestamps
    end
    add_column :suites, :project_id, :uuid
    if Suite.any?
      project = Project.new(:name => "Default", :user => User.where(:admin => true).first)
      project.save(:validate => false)
      Suites.all.each do |suite|
        suite.project = project
        suite.save!
      end
    end
  end
end
