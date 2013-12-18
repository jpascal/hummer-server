class RootController < ApplicationController
  def index
    @projects = Project.limit(5).order("created_at desc")
    @suites = Suite.limit(5).order("created_at desc")
    @bugs = Bug.limit(5).order("created_at desc")
  end
end
