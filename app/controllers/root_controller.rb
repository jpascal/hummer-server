class RootController < ApplicationController
  def index
    @suites = Suite.best_builds
  end
end
