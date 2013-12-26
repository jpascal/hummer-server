class RootController < ApplicationController
  def index
    @projects = Project.for(current_user).limit(5).order("created_at desc")
    @suites = Suite.where(:project_id => @projects.ids).limit(5).order("created_at desc")
    @bugs = Bug.joins(:case).where(:cases => {:suite_id => @suites.ids}).limit(5).order("created_at desc")
  end
end
